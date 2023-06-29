class CreateVariations < ActiveRecord::Migration[6.1]
  def change
    create_table :variations do |t|
      t.string :name
      t.string :color
      t.string :type
      t.references :product, null: false, foreign_key: true

      t.timestamps
    end
  end
end
