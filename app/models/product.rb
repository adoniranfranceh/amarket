class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :admin
  has_and_belongs_to_many :sales
  has_many :variations
  has_one_attached :image
end
