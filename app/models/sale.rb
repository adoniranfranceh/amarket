class Sale < ApplicationRecord
  after_create :product_from_inventary_to_sale
  before_save :set_completed_at
  has_and_belongs_to_many :products
  belongs_to :admin
  belongs_to :customer
  validates :customer, :products, :comments, presence: true

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
