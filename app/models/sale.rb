class Sale < ApplicationRecord
  before_save :set_completed_at
  has_and_belongs_to_many :secondaryproducts
  belongs_to :admin
  belongs_to :customer
  validates :customer, :secondaryproducts, :quantity, :total_price, presence: true
  validate :cash_is_open

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

  def cash_is_open
    unless current_admin&.cash&.open?
      errors.add(:base, "Não há caixa aberto para realizar a venda.")
    end
  end
end
