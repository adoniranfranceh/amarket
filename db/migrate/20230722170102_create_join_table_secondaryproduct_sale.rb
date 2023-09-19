class CreateJoinTableSecondaryproductSale < ActiveRecord::Migration[6.1]
  def change
    create_join_table :secondaryproducts, :sales do |t|
      t.index [:secondaryproduct_id, :sale_id], name: 'index_secondaryproducts_sales'
      t.index [:sale_id, :secondaryproduct_id], name: 'index_sales_secondaryproducts'
    end
  end
end
