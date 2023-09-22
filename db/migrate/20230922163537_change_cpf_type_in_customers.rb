class ChangeCpfTypeInCustomers < ActiveRecord::Migration[6.0]
  def up
    change_column :customers, :cpf, :string
  end

  def down
    change_column :customers, :cpf, :integer
  end
end
