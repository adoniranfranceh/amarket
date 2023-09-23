class Secondaryproduct < ApplicationRecord
  belongs_to :admin
  belongs_to :product
  belongs_to :variation, optional: true
  belongs_to :subgroup, optional: true
  has_and_belongs_to_many :sales
  before_update :update_product_quantity

  scope :search, -> (term) {
    return all unless term.present?
    where("LOWER(secondaryproducts.name) LIKE ?", "%#{term.downcase}%")
  }

  def image_url
    if self.variation
      variation.image_url
    else
      product.image_url
    end
  end

  def update_product_quantity
    if variation.blank?
      self.product.update(quantity: self.quantity)
    else
      if subgroup.blank?
        var = Variation.find(self.variation.id)
        var.update(variation_quantity: self.quantity)
      else
        subg = Subgroup.find(self.subgroup.id)
        subg.update(quantity: self.quantity)
      end
    end
  end
end
