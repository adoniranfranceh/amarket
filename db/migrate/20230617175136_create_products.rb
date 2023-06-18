class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :descryption
      t.references :category, null: true, foreign_key: true
      t.string :brand
      t.float :purchase_price
      t.float :sale_price
      t.integer :quantity
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
