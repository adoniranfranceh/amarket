class AdminTemplate::ProductsController < AdminTemplateController
  def index
    @products = current_admin.products
  end
end
