class AddCashRegisterIdToSales < ActiveRecord::Migration[6.1]
  def change
    add_reference :sales, :cash_register, null: false, foreign_key: true
  end
end
