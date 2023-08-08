module CashHelper
  def current_total_cash
    @cash_register.cash_total + @cash_register.initial_value
  end
end