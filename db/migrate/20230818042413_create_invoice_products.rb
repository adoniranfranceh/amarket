class CreateInvoiceProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_products do |t|
      t.string :name
      t.integer :quantity
      t.float :sale_price
      t.references :sale, null: false, foreign_key: true

      t.timestamps
    end
  end
end
