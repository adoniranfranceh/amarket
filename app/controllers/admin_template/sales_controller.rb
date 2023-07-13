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
    @sale = current_admin.sales.build(sale_params)
    products_ids = params[:sale][:product_id].split(',')

    products_ids.each do |product_id|
      product = Product.find_by(id: product_id)
      @sale.products << product if product
    end

    respond_to do |format|
      if @sale.save
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
                                 :product_id,
                                 :total_price,
                                 :payment_method,
                                 :status,
                                 :completed_at,
                                 :discount,
                                 :quantity,
                                 :comments
                                )
  end
end
