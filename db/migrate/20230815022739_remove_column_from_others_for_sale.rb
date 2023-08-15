class RemoveColumnFromOthersForSale < ActiveRecord::Migration[6.1]
  def change
    remove_column :others_for_sales, :taxes, :float
    remove_column :others_for_sales, :discount, :float
  end
end
