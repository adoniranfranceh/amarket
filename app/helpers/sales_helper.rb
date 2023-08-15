module SalesHelper
  def available_payment_methods
    ['Pix', 'Dinheiro' , 'Cartão de Débito', 'Cartão de Crédito', 'Transferência Bancária', 'Outros']
  end

  def available_payment_methods_others
    ['Pix', 'Dinheiro' ,'Cartão de Dédito', 'Cartão de Crédito','Transferência Bancária']
  end
end
