class AdminTemplate::InventaryController < AdminTemplateController
  def index
    @secondary_products = current_admin.secondaryproducts.where('quantity > ?', 0)
  end
end
