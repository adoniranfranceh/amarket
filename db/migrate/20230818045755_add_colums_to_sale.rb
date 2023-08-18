class AddColumsToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :Code, :string
  end
end
