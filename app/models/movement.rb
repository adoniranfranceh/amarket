class Movement < ApplicationRecord
  belongs_to :cash_register
  after_save :calc_to_cash_register
  include CashRegisterable

  def calc_to_cash_register
    cash_register = current_cash_register
    cash_register.cash_total += self.cash_deposit if self.cash_deposit.present?
    cash_register.cash_total -= self.cash_withdrawal if self.cash_withdrawal.present? && cash_register.cash_total >= self.cash_withdrawal
    cash_register.save
  end
end
