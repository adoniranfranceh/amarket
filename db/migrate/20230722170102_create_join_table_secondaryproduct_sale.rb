class CreateJoinTableSecondaryproductSale < ActiveRecord::Migration[6.1]
  def change
    create_join_table :secondaryproducts, :sales do |t|
      t.index [:secondaryproduct_id, :sale_id]
      t.index [:sale_id, :secondaryproduct_id]
    end
  end
end
