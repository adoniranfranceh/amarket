class Sale < ApplicationRecord
  before_save :set_completed_at
  after_save :movement_for_sale
  has_and_belongs_to_many :secondaryproducts
  belongs_to :admin
  belongs_to :customer
  belongs_to :cash_register
  validates :customer, :secondaryproducts, :quantity, :total_price, presence: true
  include CashRegisterable

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

  def movement_for_sale
    sale_registers = Sale.where(cash_register_id: current_cash_register.id)
    moviments = 0
    sale_registers.each do |sale|
      moviments += sale.total_price
    end
    total_calc = current_cash_register.cash_total + moviments
    current_cash_register.update(cash_total: total_calc)
  end
end
