class Variation < ApplicationRecord
  belongs_to :product
  has_many :subgroups, dependent: :destroy
  accepts_nested_attributes_for :subgroups, reject_if: :all_blank, allow_destroy: true
  has_one_attached :photo
  before_save :quantity_for_subgroups
  before_update :quantity_for_subgroups

  def image_url
    if photo.attached?
      photo.url
    else
      '/assets/no_image.png'
    end
  end

  def quantity_for_subgroups
    
  end
end
