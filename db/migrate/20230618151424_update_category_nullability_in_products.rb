class UpdateCategoryNullabilityInProducts < ActiveRecord::Migration[6.1]
  def change
    change_column_null :products, :category_id, true
  end
end
