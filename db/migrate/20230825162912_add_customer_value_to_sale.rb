class AddCustomerValueToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :customer_value, :float
  end
end
