class CreateCashRegisters < ActiveRecord::Migration[6.1]
  def change
    create_table :cash_registers do |t|
      t.references :cash, null: false, foreign_key: true
      t.float :initial_value
      t.datetime :opening_time
      t.datetime :closing_time

      t.timestamps
    end
  end
end
