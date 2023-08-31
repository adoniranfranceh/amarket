class AddChangeToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :change, :float
  end
end
