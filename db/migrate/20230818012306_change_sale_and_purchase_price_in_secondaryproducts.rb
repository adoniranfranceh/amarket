class ChangeSaleAndPurchasePriceInSecondaryproducts < ActiveRecord::Migration[6.1]
  def change
    change_column :secondaryproducts, :sale_price, :decimal, precision: 10, scale: 2
    change_column :secondaryproducts, :purchase_price, :decimal, precision: 10, scale: 2
  end
end
