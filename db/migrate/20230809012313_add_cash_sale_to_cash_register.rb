class AddCashSaleToCashRegister < ActiveRecord::Migration[6.1]
  def change
    add_column :cash_registers, :cash_sale, :float
  end
end
