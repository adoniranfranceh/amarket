class AddDiscountToSale < ActiveRecord::Migration[6.1]
  def change
    add_column :sales, :discount, :integer
  end
end
