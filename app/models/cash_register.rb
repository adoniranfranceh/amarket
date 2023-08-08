class CashRegister < ApplicationRecord
  belongs_to :cash
  has_many :movements
  has_many :sales
  validates :initial_value, presence: true
end
