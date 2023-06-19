class AdminTemplate::Inventary::ProductsController < AdminTemplateController
  def index
    @products = current_admin.products.where('quantity > ?', 0)
  end
end

