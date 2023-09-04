class CreateCompanies < ActiveRecord::Migration[6.1]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :cnpj
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
