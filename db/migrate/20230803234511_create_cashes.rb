class CreateCashes < ActiveRecord::Migration[6.1]
  def change
    create_table :cashes do |t|
      t.string :cash_name
      t.boolean :is_open
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
