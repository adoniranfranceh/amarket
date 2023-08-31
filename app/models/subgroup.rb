class Subgroup < ApplicationRecord
  belongs_to :variation
  has_one :secondaryproduct, dependent: :destroy
  after_save :subgroup_quantity_to_variation
  after_update :subgroup_quantity_to_variation
  after_destroy :subgroup_quantity_to_variation

  def subgroup_quantity_to_variation
    self.variation.update(variation_quantity: self.variation.subgroups.sum(:quantity))
  end
end
