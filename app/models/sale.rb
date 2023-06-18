class Sale < ApplicationRecord
  belongs_to :product
  belongs_to :admin
end
