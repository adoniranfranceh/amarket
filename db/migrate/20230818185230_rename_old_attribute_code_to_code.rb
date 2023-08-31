class RenameOldAttributeCodeToCode < ActiveRecord::Migration[6.1]
  def change
     rename_column :sales, :Code, :code
  end
end
