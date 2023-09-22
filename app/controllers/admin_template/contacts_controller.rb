class AdminTemplate::ContactsController < AdminTemplateController
  def index
    @customers = current_admin.customers
                          .where("phone IS NOT NULL AND phone != '' OR email IS NOT NULL AND email != ''")
                          .search(params[:search])
                          .search_by_date(params[:search_date])
                          .includes(:admin)
                          .order(created_at: :desc)
                          .page(params[:page]).per(5)

  end
end
