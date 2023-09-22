class AdminTemplate::HomeController < AdminTemplateController
  def index
    choose_date_request
    sales_completed = @sales.where(status: 'completed')
    @total = sales_completed.sum(:total_price)
    select_product_info
    @birthdays_of_the_month = current_admin.customers.where("extract(month from date_of_birth) = ?", @choose_date.month.to_s)
    @total_text = "(mês de #{I18n.l(@choose_date, format: "%B")})"
  end

  def last_seven_days(other_or_date_current)
    start_date = other_or_date_current - 7.days
    end_date = other_or_date_current

    all_dates_last_days = (start_date..end_date).to_a
    @day_names = all_dates_last_days.map do |date|
      formatted_date = (date == Date.current) ? "#{I18n.l(date, format: '%A')} (Hoje)" : I18n.l(date, format: '%A')
      formatted_date
    end

    sales_data = current_admin.sales
      .where(created_at: start_date.beginning_of_day..end_date.end_of_day, status: 'completed')
      .group("DATE(created_at)")
      .count

    @data = all_dates_last_days.map { |date| sales_data[date] || 0 }
  end

  def customer_info_select(other_or_month_current)
    @start_month = other_or_month_current - 5.month
    all_months = (@start_month..other_or_month_current).to_a
    @month_names = all_months.map do |month|
      month.month == Date.today.month ? "#{I18n.l(month, format: '%B')} (mês atual)" : I18n.l(month, format: '%B')
    end.uniq

    @data_monthly = current_admin.customers.where(created_at: all_months.first..all_months.last).group("DATE(created_at)").count.values
  end

  def choose_date_request
    @choose_date = params[:choose_date].present? ? Date.parse(params[:choose_date]) : Date.today
    if @choose_date == Date.today
      @sales = current_admin.sales.within_current_month.where(status: 'completed')
      @text = '(mês atual)'
      @customers = current_admin.customers.within_current_month
      @products = current_admin.products.within_current_month
      @secondary_products = current_admin.secondaryproducts
      last_seven_days(Date.current)
      customer_info_select(Date.current)
    else
      @sales = current_admin.sales.within_selected_day(@choose_date).where(status: 'completed')
      @text = "(#{I18n.l(@choose_date, format: "%d de %B")})"
      @customers = current_admin.customers.within_selected_month(@choose_date)
      @products = current_admin.products.within_selected_month(@choose_date)
      @secondary_products = current_admin.secondaryproducts.within_selected_month(@choose_date)
      last_seven_days(@choose_date)
      customer_info_select(@choose_date)
    end
  end

  private

  def sales_for_payment_method
    @sales_for_money = @sales.where(payment_method: 'Dinheiro')
    @sales_for_money = @sales.where(payment_method: 'Cartão de Dédito')
    @sales_for_money = @sales.where(payment_method: 'Pix')
    @sales_for_money = @sales.where(payment_method: 'Cartão de Crédito')
    @sales_for_money = @sales.where(payment_method: 'Transferência Bancária')
  end

  def select_product_info
    product_data = select_product_query

    @product_selected = []
    @quantity_of_sales = []

    product_data.each do |product|
      @product_selected << product.name
      @quantity_of_sales << product.total_secondary_sales
    end

    puts "#{@product_selected} produtos <<<<<<<<<<<<<<<<<<<<<"
    puts "#{@quantity_of_sales} quantidade"
    puts "#{@sales.all_month_accurately(@choose_date)}<<<<<<<<<<<<<<<<<<<<<log DO INTERVALO MENSAL"
  end

  def select_product_query
    current_admin.products.joins(:sales)
                  .where(sales: { created_at: @sales.all_month_accurately(@choose_date), status: 'completed' })
                  .group('products.id')
                  .order(Arel.sql('COUNT(sales.id) DESC'))
                  .limit(10)
                  .select('products.*, COUNT(products.id) as total_secondary_sales')
  end
end
