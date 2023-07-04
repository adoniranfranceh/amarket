class CreateSubgroups < ActiveRecord::Migration[6.1]
  def change
    create_table :subgroups do |t|
      t.string :size
      t.float :number
      t.integer :quantity
      t.references :variation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
