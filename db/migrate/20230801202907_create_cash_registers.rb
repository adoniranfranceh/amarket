class CreateCashRegisters < ActiveRecord::Migration[6.1]
  def change
    create_table :cash_registers do |t|
      t.bolean :open?
      t.float :inital_value
      t.references :admin_id, null: false, foreign_key: true

      t.timestamps
    end
  end
end
