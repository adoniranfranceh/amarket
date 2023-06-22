class AdminTemplate::SalesController < AdminTemplateController

  def index
    @sales = current_admin.sales
  end

  def new
    @customers = current_admin.customers
    @products = current_admin.products.to_json
  end

  def create
  end

  private
  def sale_params
    params.require(:sale).permit(:customer_id,
                                 :products_id,
                                 :total_price,
                                 :payment_at,
                                 :status,
                                 :completed_at
                                )
  end
end
