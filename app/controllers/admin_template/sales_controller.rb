class AdminTemplate::SalesController < AdminTemplateController
  before_action :set_customers_and_products, only: [:new]
  skip_before_action :verify_authenticity_token, only: [:create]

  def index
    @sales = current_admin.sales
  end

  def new
    @sale = current_admin.sales.build
  end

  def create
    logger.info "Received params: #{params.inspect} <<<<<<<<<<<<<<<<<<<<,"
    @sale = current_admin.sales.build(sale_params)
    secondary_ids = params[:sale][:secondaryproduct_ids].split(',')

    secondary_ids.each do |secondary_id|
      secondary = Secondaryproduct.find_by(id: secondary_id)
      @sale.secondaryproducts << secondary if secondary
    end

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
    params.require(:sale).permit(:customer_id,
                                 :secondaryproduct_ids,
                                 :total_price,
                                 :payment_method,
                                 :status,
                                 :completed_at,
                                 :discount,
                                 :quantity,
                                 :comments
                                )
  end

  def update_product_quantities(sale)
    sale.secondaryproducts.each do |product|
      quantity_sold = params["quantity_for_product#{product.id}"].to_i
      total = product.quantity - quantity_sold
      product.update(quantity: total)
    end
  end
end
