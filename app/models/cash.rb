class Cash < ApplicationRecord
  belongs_to :admin
  has_many :cash_registers
end
