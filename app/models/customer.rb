class Customer < ApplicationRecord
  belongs_to :admin
  has_many :customers
  validates :name, presence: true
end
