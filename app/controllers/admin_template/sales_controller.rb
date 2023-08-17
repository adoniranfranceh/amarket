class AdminTemplate::SalesController < AdminTemplateController
  before_action :set_customers_and_products, only: [:new]
  skip_before_action :verify_authenticity_token, only: [:create]
  before_action :cash_is_open?, only: [:new, :create]
  include CashRegisterable

  def index
    @sales = current_admin.sales.order(created_at: :desc)
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

    cash_register = CashRegister.find_by(closing_time: nil)
    @sale.cash_register = cash_register if cash_register

    respond_to do |format|
      if @sale.save
        update_product_quantities(@sale)
        format.html { redirect_to admin_template_sales_path, notice: 'Nova venda feita com sucesso!' }
        format.json { render json: @sale, status: :created }
      else
        puts @sale.errors.full_messages
        format.html { render :new }
        format.json { render json: { errors: @sale.errors.full_messages }, status: 422 }
      end
    end
  end

  def show
    @sale = Sale.find(params[:id])
  end

  private
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
                                  :secondaryproduct_ids,
                                  secondaryproduct_ids: [],
                                  others_for_sales_attributes:[
                                    :id,
                                    :payment_method,
                                    :other_value,
                                    :_destroy
                                  ]
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
