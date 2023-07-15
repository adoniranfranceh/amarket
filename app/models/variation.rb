class Variation < ApplicationRecord
  belongs_to :product
  has_many :subgroups
  accepts_nested_attributes_for :subgroups, reject_if: :all_blank, allow_destroy: true
  has_one_attached :photo

  def image_url
    if photo.attached?
      photo.url
    else
      '/assets/no_image.png'
    end
  end
end
