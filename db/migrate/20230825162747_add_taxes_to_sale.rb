class AddTaxesToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :taxes, :float
  end
end
