class AddColumsToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :taxes, :float
    add_column :sales, :customer_value, :float
    add_column :sales, :change, :float
  end
end
