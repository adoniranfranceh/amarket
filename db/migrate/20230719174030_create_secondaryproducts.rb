class CreateSecondaryproducts < ActiveRecord::Migration[6.1]
  def change
    create_table :secondaryproducts do |t|
      t.string :name
      t.integer :quantity
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
