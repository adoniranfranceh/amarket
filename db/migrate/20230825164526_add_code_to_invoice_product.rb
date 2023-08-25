class AddCodeToInvoiceProduct < ActiveRecord::Migration[6.1]
  def change
    add_column :invoice_products, :code, :string
  end
end
