class Variation < ApplicationRecord
  belongs_to :product
  has_many :subgroups, dependent: :destroy
  has_many :secondaryproduct, dependent: :destroy
  accepts_nested_attributes_for :subgroups, reject_if: :all_blank, allow_destroy: true
  has_one_attached :photo
  after_save :variation_quantity_to_product
  after_destroy :variation_quantity_to_product


  def image_url
    if photo.attached?
      photo.url
    else
      '/assets/no_image.png'
    end
  end

  def variation_quantity_to_product
    self.product.update(quantity: self.product.variations.sum(:variation_quantity))
  end
end
