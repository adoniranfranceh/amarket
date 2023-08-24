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

  scope :search, -> (term) {
    return all unless term.present?
    joins(:customer).where("LOWER(customers.name) LIKE ? OR LOWER(code) LIKE ?", "%#{term.downcase}%", "%#{term.downcase}%")
  }
  scope :search_by_date, -> (date) {
    return all unless date.present?
    where("DATE(created_at) = ?", date)
  }

  scope :search_by_date_range, -> (start_date, end_date) {
    return all unless start_date.present? || end_date.present?

    if start_date.present? && end_date.present?
      where(created_at: start_date.beginning_of_day..end_date.end_of_day)
    elsif start_date.present?
      where("created_at >= ?", start_date.beginning_of_day)
    elsif end_date.present?
      where("created_at <= ?", end_date.end_of_day)
    end
  }


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
