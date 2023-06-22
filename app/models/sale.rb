class Sale < ApplicationRecord
  before_save :set_completed_at if
  belongs_to :product
  belongs_to :admin
  belongs_to :customer

  STATUS_OPTIONS = {
    pending: 'Pendente',
    in_progress: 'Em andamento',
    completed: 'Concluído',
    canceled: 'Cancelado',
    refunded: 'Reembolsada',
    awaiting_payment: 'Aguardando pagamento',
    in_review: 'Em análise'
  }.freeze

  private
  def set_completed_at
    self.completed_at = Time.zone.now if status == 'Concluído' && status_changed?
  end
end
