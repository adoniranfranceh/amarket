module CashRegisterable
  extend ActiveSupport::Concern

  included do 
    def current_cash_register
      CashRegister.find_by(closing_time: nil)
    end
  end
end