class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :admin
  has_and_belongs_to_many :sales
  has_one_attached :image
  has_many :variations
  accepts_nested_attributes_for :variations, reject_if: :all_blank, allow_destroy: true

  def full_name
    self.brand.present? ? [self.name, self.brand].join(' - ') : self.name
  end
end
