class CreateOthersForSales < ActiveRecord::Migration[6.1]
  def change
    create_table :others_for_sales do |t|
      t.string :payment_method
      t.float :other_value
      t.references :sale, null: false, foreign_key: true

      t.timestamps
    end
  end
end
