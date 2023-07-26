class AdminTemplate::HomeController < AdminTemplateController
  def index

    @choose_date = Date.new(2023, 7, 25)
    @total = 0
    @sales = current_admin.sales.where("DATE(created_at) = ?", @choose_date).each { |sale|
      @total += sale.total_price
    }

    @secondary_products = current_admin.secondaryproducts
  end
end
