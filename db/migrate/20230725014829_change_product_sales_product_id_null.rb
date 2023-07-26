class ChangeProductSalesProductIdNull < ActiveRecord::Migration[6.1]
  def change
     change_column_null :products_sales, :product_id, true
  end
end
