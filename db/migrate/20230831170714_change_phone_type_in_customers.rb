class ChangePhoneTypeInCustomers < ActiveRecord::Migration[6.0]
  def change
    change_column :customers, :phone, :string
  end
end
