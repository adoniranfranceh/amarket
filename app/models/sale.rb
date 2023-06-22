class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :admin
  belongs_to :customer
end
