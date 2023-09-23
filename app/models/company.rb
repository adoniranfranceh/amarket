class Company < ApplicationRecord
  belongs_to :admin
  has_one_attached :logo

  def image_url
    if logo.attached?
      logo.url
    else
      '/assets/no_image.png'
    end
  end


  def cnpj=(value)
    self[:cnpj] = value.gsub(/\D/, '')
  end

  include CnpjValidatable
end
