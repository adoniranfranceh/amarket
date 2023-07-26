class Variation < ApplicationRecord
  belongs_to :product
  has_many :subgroups, dependent: :destroy
  has_many :secondaryproduct, dependent: :destroy
  accepts_nested_attributes_for :subgroups, reject_if: :all_blank, allow_destroy: true
  has_one_attached :photo
  after_save :variation_quantity_to_product
  after_update :variation_quantity_to_product

  def image_url
    if photo.attached?
      photo.url
    else
      '/assets/no_image.png'
    end
  end

  private

  def variation_quantity_to_product
    total_quantity_product = 0
    self.product.variations.each do |variation|
      total_quantity_product += variation.variation_quantity
      puts "#{variation.variation_quantity} <<<<<<<<<<<,"
    end
    self.product.update(quantity: total_quantity_product)
    puts total_quantity_product
    puts 'total product <<<<<<<<<<<<<<<<<<<<<<<<'
  end
end
