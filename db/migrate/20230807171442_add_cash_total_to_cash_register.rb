class AddCashTotalToCashRegister < ActiveRecord::Migration[6.1]
  def change
    add_column :cash_registers, :cash_total, :float
  end
end
