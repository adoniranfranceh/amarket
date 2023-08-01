class AdminTemplate::HomeController < AdminTemplateController
  def index
    choose_date_request
    @total = @sales.sum(:total_price)
    select_product_info
  end

  def last_seven_days(other_or_date_current)
    start_date = other_or_date_current - 6.days
    all_dates_last_days = (start_date..other_or_date_current).to_a
    @day_names = all_dates_last_days.map { |date| date == Date.current ? "#{I18n.l(date, format: '%A')} (Hoje)" : I18n.l(date, format: '%A') }

    sales_data = current_admin.sales
      .where(created_at: all_dates_last_days.first..all_dates_last_days.last)
      .group("DATE(created_at)")
      .count

    @data = all_dates_last_days.map { |date| sales_data[date.to_s] || 0 }
  end

  def customer_info_select(other_or_month_current)
    @start_month = other_or_month_current - 5.month
    all_months = (@start_month..other_or_month_current).to_a
    @month_names = all_months.map do |month|
      month.month == Date.current.month ? "#{I18n.l(month, format: '%B')} (mês atual)" : I18n.l(month, format: '%B')
    end.uniq

    @data_monthly = current_admin.customers.where(created_at: all_months.first..all_months.last).group("DATE(created_at)").count.values
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
      @text = "(#{I18n.l(@choose_date, format: "%d de %B")})"
      @customers = current_admin.customers.within_selected_month(@choose_date)
      @secondary_products = current_admin.secondaryproducts.within_selected_month(@choose_date)
      @total_text = " (mês de #{I18n.l(@choose_date, format: "%B")})"
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
