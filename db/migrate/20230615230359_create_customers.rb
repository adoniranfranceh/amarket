class CreateCustomers < ActiveRecord::Migration[6.1]
  def change
    create_table :customers do |t|
      t.string :name
      t.integer :phone
      t.string :email
      t.string :city
      t.string :neighborhood
      t.string :andress
      t.string :house_number
      t.integer :cpf
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
