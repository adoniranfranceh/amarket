class AdminTemplate::InventaryController < AdminTemplateController
  def index
    @secondary_products = current_admin.secondaryproducts
                                        .where("quantity > 0")
                                        .search(params[:search])
                                        .page(params[:page]).per(5)
  end
end
