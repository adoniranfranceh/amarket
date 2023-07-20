class Secondaryproduct < ApplicationRecord
  belongs_to :admin
  belongs_to :product
  has_one_attached :image

  def image_url
    if image.attached?
      image.url
    else
      '/assets/no_image.png'
    end
  end
end
