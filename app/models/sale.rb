class Sale < ApplicationRecord
  after_save :set_completed_at
  has_and_belongs_to_many :secondaryproducts
  belongs_to :admin
  belongs_to :customer
  belongs_to :cash_register
  validates :customer, :secondaryproducts, :quantity, :total_price, :payment_method, :status, presence: true
  has_many :others_for_sales
  has_many :invoice_products
  accepts_nested_attributes_for :others_for_sales, allow_destroy: true, reject_if: :all_blank
  include CashRegisterable

  STATUS_OPTIONS_IN_FORM = {
    pending: 'Pendente',
    in_progress: 'Em andamento',
    completed: 'Concluído',
    in_review: 'Em análise'
  }.freeze

  STATUS_OPTIONS_IN_INDEX = {
    pending: 'Pendente',
    in_progress: 'Em andamento',
    completed: 'Concluído',
    in_review: 'Em análise'
  }.freeze

  private

  def set_completed_at
    if status == 'completed'
      self.completed_at = Time.zone.now
      movement_for_sale
    end
  end

  def movement_for_sale
    sale = Sale.where(cash_register_id: current_cash_register.id)
    total_sale = Sale.where(cash_register_id: current_cash_register.id).sum(:total_price)
    total = current_cash_register.cash_total + total_sale
    current_cash_register.update(cash_sale: total_sale, cash_total: total)
  end
end
