class AdminTemplate::HomeController < AdminTemplateController
  def index
    choose_date_request
    @total = @sales.sum(:total_price)
    select_product_info
  end

  def last_seven_days(other_or_date_current)
    start_date = other_or_date_current - 6.days
    @all_dates_last_days = (start_date..other_or_date_current).to_a
    @data = @all_dates_last_days.map do |date|
      current_admin.sales.where("DATE(created_at) = ?", date).count
    end
  end

  def customer_info_select(other_or_month_current)
    @start_month = other_or_month_current - 5.month
    @all_months = (@start_month..other_or_month_current).to_a
    @data_monthly = @all_months.map do |data|
      current_admin.customers.where("DATE(created_at) = ?", data).count
    end
  end

  def choose_date_request
    @choose_date = params[:choose_date].present? ? Date.parse(params[:choose_date]) : Date.current
    if @choose_date == Date.current
      @sales = current_admin.sales.within_current_month
      @text = '(mês atual)'
      @customers = current_admin.customers
      @secondary_products = current_admin.secondaryproducts
      last_seven_days(Date.current)
      customer_info_select(Date.current)
    else
      @sales = current_admin.sales.within_selected_day(@choose_date)
      @text = "(#{@choose_date.strftime("%d de %B")})"
      @customers = current_admin.customers.within_selected_month(@choose_date)
      @secondary_products = current_admin.secondaryproducts.within_selected_month(@choose_date)
      @total_text = " (mês de #{@choose_date.strftime("%B")})"
      last_seven_days(@choose_date)
      customer_info_select(@choose_date)
    end
  end

  private

  def select_product_info
    @product_selected = select_product_query.pluck('products.name', 'products.brand')
    @quantity_of_sales = select_product_query.count.values
  end

  def select_product_query
    current_admin.products.joins(secondaryproducts: { sales: :sales_secondaryproducts })
                  .where(sales: { created_at: @choose_date.all_month })
                  .group('products.id')
                  .order('COUNT(products.id) DESC')
                  .limit(10)
  end
end
