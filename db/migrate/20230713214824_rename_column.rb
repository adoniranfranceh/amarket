class RenameColumn < ActiveRecord::Migration[6.1]
  def change
  rename_column :variations, :type, :variation_type
end
end
