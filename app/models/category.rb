class Category < ApplicationRecord
  belongs_to :admin
  has_many :products

  scope :search, -> (term) {
    return all unless term.present?
    where("LOWER(categories.name) LIKE ? OR LOWER(categories.descryption) LIKE ?", "%#{term.downcase}%", "%#{term.downcase}%")
  }

end
