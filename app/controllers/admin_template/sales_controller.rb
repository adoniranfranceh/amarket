class AdminTemplate::SalesController < AdminTemplateController
  before_action :set_customers_and_products, only: [:new]
  def index
    @sales = current_admin.sales
  end

  def new
    @sale = current_admin.sales.build
  end

  def create
    @sale = current_admin.sales.build(sale_params)
    if @sale.save
      redirect_to admin_template_sales_path, notice: 'Nova Venda!'
    else
      render :new
      flash[:error] = 'Existem campos inválidos'
    end
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
