class AddColumnsToSecondaryproduct < ActiveRecord::Migration[6.1]
  def change
    add_reference :secondaryproducts, :variation, foreign_key: true
    add_reference :secondaryproducts, :subgroup, foreign_key: true
  end
end
