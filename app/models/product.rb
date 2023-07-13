class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :admin
  has_and_belongs_to_many :sales
  has_one_attached :image
  has_many :variations
  accepts_nested_attributes_for :variations, reject_if: :all_blank, allow_destroy: true

  validates :name, :sale_price, :purchase_price, presence: true
  validates :category_id, presence: true, unless: -> { category_id.blank? }

  def full_name
    self.brand.present? ? [self.name, self.brand].join(' - ') : self.name
  end

  def image_url
    if image.attached?
      image.url
    else
      'no_image.png'
    end
  end
end
