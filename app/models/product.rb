class Product < ApplicationRecord
  belongs_to :category, optional: true
  belongs_to :admin
  has_and_belongs_to_many :sales
  has_one_attached :image
  has_many :variations, dependent: :destroy
  has_many :secondaryproducts, dependent: :destroy
  accepts_nested_attributes_for :variations, reject_if: :all_blank, allow_destroy: true

  validates :name, :sale_price, :purchase_price, presence: true
  validates :category_id, presence: true, unless: -> { category_id.blank? }

  scope :search, -> (term) {
    return all unless term.present?
    where("LOWER(products.name) LIKE ? OR LOWER(products.descryption) LIKE ?", "%#{term.downcase}%", "%#{term.downcase}%")
  }

  def full_name
    self.brand.present? ? [self.name, self.brand].join(' - ') : self.name
  end

  def image_url
    variation_with_image = variations.find { |variation| variation.photo.attached? }

    if variation_with_image
      variation_with_image.image_url
    elsif image.attached?
      image.url
    else
      '/assets/no_image.png'
    end
  end

  private

  def quantity_for_variations
    if self.variations.present?
      total_quantity = 0
      self.variations.each do |variation|
        total_variation = 0
        if variation.subgroups.present?
          variation.subgroups.each do |subgroup|
            total_variation += subgroup.quantity
          end
        end
        total_quantity += variation.variation_quantity
      end
      self.quantity = total_quantity
    end
  end
end
