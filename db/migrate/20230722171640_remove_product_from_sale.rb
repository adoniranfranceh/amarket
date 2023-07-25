class RemoveProductFromSale < ActiveRecord::Migration[6.1]
  def change
    remove_column :sales, :product_id
  end
end
