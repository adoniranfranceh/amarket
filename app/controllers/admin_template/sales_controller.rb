class AdminTemplate::SalesController < AdminTemplateController
  before_action :set_customers_and_products, only: [:new]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :cash_is_open?, only: [:new, :create]
  skip_before_action :verify_authenticity_token, only: [:validate_admin_password]

  include CashRegisterable
  include Code
  include DecimalCoin

  def index
    @sales = current_admin.sales.includes(:customer)
             .where(admin_id: current_admin.id)
             .search(params[:search])
             .search_by_date(params[:search_date])
             .order(created_at: :desc)
             .page(params[:page]).per(5)
  end

  def new
    @sale = current_admin.sales.build
  end

  def create
    @sale = current_admin.sales.build(sale_params)
    secondary_ids = params[:sale][:secondaryproduct_ids].split(',')

    secondary_ids.each do |secondary_id|
      secondary = Secondaryproduct.find_by(id: secondary_id)
      @sale.secondaryproducts << secondary if secondary
    end

    cash_register = current_cash_register
    @sale.cash_register = cash_register if cash_register
    @sale.code = generate_unique_code

    respond_to do |format|
      if @sale.save
        create_invoice_products(@sale)
        update_product_quantities(@sale)
        format.html { redirect_to admin_template_sales_path, notice: 'Nova venda feita com sucesso!' }
        format.json { render json: @sale, status: :created }
      else
        puts @sale.errors.full_messages
        format.html { render :index, flash[:error] = 'Houve algum problema ao tentar concluir a venda' }
        format.json { render json: { errors: @sale.errors.full_messages }, status: 422 }
      end
    end
  end

  def validate_admin_password
    admin = current_admin
    password = params[:password]

    if admin.valid_password?(password)
      render json: { valid: true }
    else
      render json: { valid: false }
    end
  end


  def update_status
    @sale = Sale.find(params[:id])
    new_status = params[:new_status]

    if new_status == 'devolution'
      total_devolution = 0
      @sale.secondaryproducts.each do |product|
        total_devolution += product.sale_price
      end

      if current_cash_register.cash_total < total_devolution
        nested_value = total_devolution - current_cash_register.cash_total
        flash[:error] = "O valor da devolução é maior que o total em caixa. Necessário #{format_to_decimal(nested_value)}"
      else
        if @sale.update(status: "Devolvido em #{Date.current.strftime('%d/%m/%Y')}", total_price: 0)
          current_cash_register.movements.create(cash_withdrawal: total_devolution, reason: 'Devolução de venda')
          flash[:notice] = 'Status atualizado com sucesso!'
        else
          flash[:error] = 'Erro ao atualizar o status.'
        end
      end
    else
      if @sale.update!(status: new_status)
        flash[:notice] = 'Status atualizado com sucesso!'
      else
        flash[:error] = 'Erro ao atualizar o status: ' + @sale.errors.full_messages.join(', ')
      end
    end

    redirect_to admin_template_sales_path
  end

  def show_invoice
    @sale = Sale.find(params[:id])
    @invoice_product = @sale.invoice_products
    @products = @invoice_product
    @customer = @sale.customer
    @seller = @sale.admin
    @total = @sale.total_price

    respond_to do |format|
      format.html
      format.pdf do
        if @sale.status == 'completed'
          pdf = generate_invoice_pdf(@sale, @products, @customer, @seller, @total)
          pdf_filename = "nota_de_compra_#{@sale.id}_#{@sale.created_at.strftime('%Y%m%d%H%M%S')}.pdf"
          send_data pdf, filename: pdf_filename, type: 'application/pdf', disposition: 'inline'
        else
          flash[:error] = 'A nota fiscal só pode ser gerada para vendas concluídas.'
        end
      end
    end
  end

  private

  def create_invoice_products(sale)
    sale.secondaryproducts.each do |product|
      quantity = params["quantity_for_product#{product.id}"].to_i
      puts quantity
      InvoiceProduct.create!(
        sale: sale,
        name: product.name,
        quantity: quantity,
        sale_price: product.sale_price
      )
    end
  end

  def generate_invoice_pdf(sale, products, customer, seller, total)
    pdf = Prawn::Document.new(page_size: 'A7', margin: [10, 10, 10, 10])
    line = '--------------------------------------------------------'

    pdf.font_size 10

    pdf.text 'CUPOM FISCAL', align: :center, style: :bold, size: 14
    pdf.text line
    pdf.text "COD: #{sale.code}"

    pdf.text "Data: #{sale.created_at.strftime('%d/%m/%Y %H:%M')}"
    pdf.text "Cliente: #{customer.name}"
    pdf.text "Vendedor: #{seller.full_name_admin}"
    pdf.text line

    pdf.text 'Produtos:'
    products_details = products.map do |product|
      "#{product.id} - #{product.name} #{product.quantity} UN - #{format_to_decimal(product.sale_price * product.quantity)}"
    end
    pdf.text products_details.join("\n")
    pdf.text "Total de itens #{sale.quantity}"

    pdf.text line
    pdf.text "#{sale.payment_method}: #{format_to_decimal(sale.customer_value)}"
    pdf.text "Troco: #{sale.change}"
    pdf.text "Desconto: #{sale.discount}"
    pdf.text "Juros: #{sale.taxes}"
    pdf.font_size 11
    pdf.text "TOTAL: #{format_to_decimal(total)}"

    pdf.text "Concluída em #{sale.updated_at.strftime('%d/%m/%Y %H:%M')}"

    pdf.move_down 5

    qr_code = RQRCode::QRCode.new("#{invoice_admin_template_sale_url(sale, format: :pdf)}")
    qr_code_img = qr_code.as_png(size: 150)
    pdf.image StringIO.new(qr_code_img.to_s), width: 100, height: 100, position: :center

    pdf.render
  end

  def set_customers_and_products
    @customers = current_admin.customers
    @products = current_admin.products
  end

  def sale_params
    params.require(:sale).permit(
                                  :customer_id,
                                  :total_price,
                                  :payment_method,
                                  :status,
                                  :completed_at,
                                  :discount,
                                  :quantity,
                                  :comments,
                                  :taxes,
                                  :customer_value,
                                  others_for_sales_attributes: [
                                    :id,
                                    :payment_method,
                                    :other_value,
                                    :_destroy
                                  ],
                                  secondaryproduct_ids: [:id, :quantity]
                                )
  end


  def update_product_quantities(sale)
    sale.secondaryproducts.each do |product|
      quantity_sold = params["quantity_for_product#{product.id}"].to_i
      total = product.quantity - quantity_sold
      product.update(quantity: total)
    end
  end

  def cash_is_open?
    cash_register = current_cash_register
    unless cash_register
      flash[:error] = 'O caixa não está aberto. Não é possível criar uma venda.'
      redirect_to admin_template_sales_path
    end
  end
end
