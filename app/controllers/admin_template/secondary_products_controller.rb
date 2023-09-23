class AdminTemplate::SecondaryProductsController < AdminTemplateController
  def index
    @secondary_products = current_admin.secondaryproducts
                                        .search(params[:search])
                                        .page(params[:page]).per(5)
  end
end
