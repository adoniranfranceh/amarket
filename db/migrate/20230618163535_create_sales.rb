class CreateSales < ActiveRecord::Migration[6.1]
  def change
    create_table :sales do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :quantity
      t.float :total_price
      t.string :payment_method
      t.datetime :completed_at
      t.string :status
      t.string :comments
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
