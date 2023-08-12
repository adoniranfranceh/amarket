class CreateProfileAdmins < ActiveRecord::Migration[6.1]
  def change
    create_table :profile_admins do |t|
      t.string :first_name
      t.string :last_name
      t.references :admin, null: false, foreign_key: true

      t.timestamps
    end
  end
end
