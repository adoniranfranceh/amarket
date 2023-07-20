class AddColumnsToProductSecondary < ActiveRecord::Migration[6.1]
  def change
    add_column :secondaryproducts, :admin_id, :integer
    add_foreign_key :secondaryproducts, :admins, column: :admin_id
    add_column :secondaryproducts, :sale_price, :integer
    add_column :secondaryproducts, :purchase_price, :integer
  end
end
