class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :admin
  belongs_to :customer

  STATUS_OPTIONS = {
    pending: 'Pendente',
    in_progress: 'Em andamento',
    completed: 'Concluída',
    canceled: 'Cancelada',
    refunded: 'Reembolsada',
    awaiting_payment: 'Aguardando pagamento',
    in_review: 'Em análise'
  }.freeze
end
