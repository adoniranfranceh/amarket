class AdminTemplate::SecondaryProductsController < AdminTemplateController
  def index
    @secondary_products = current_admin.secondaryproducts
  end
end