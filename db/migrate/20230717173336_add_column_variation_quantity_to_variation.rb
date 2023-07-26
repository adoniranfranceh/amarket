class AddColumnVariationQuantityToVariation < ActiveRecord::Migration[6.1]
  def change
    add_column :variations, :variation_quantity, :integer
  end
end
