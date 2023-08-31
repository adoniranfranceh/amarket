class CashRegister < ApplicationRecord
  belongs_to :cash
  has_many :movements
  has_many :sales
  validates :initial_value, presence: true
  validates :cash_total, numericality: { greater_than_or_equal_to: 0, allow_nil: true }

  scope :within_date_range, -> (date) {
    where(created_at: date.beginning_of_day..date.end_of_day)
  }
end
