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
end