class CreateMovements < ActiveRecord::Migration[6.1]
  def change
    create_table :movements do |t|
      t.float :cash_withdrawal
      t.float :cash_deposit
      t.string :reason
      t.references :cash_register, null: false, foreign_key: true

      t.timestamps
    end
  end
end
