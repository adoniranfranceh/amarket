class Subgroup < ApplicationRecord
  belongs_to :variation
  has_one :secondaryproduct, dependent: :destroy
  after_save :subgroup_quantity_to_variation
  after_update :subgroup_quantity_to_variation

  def subgroup_quantity_to_variation
    total_quantity_variation = 0
    self.variation.subgroups.each do |subgroup|
      total_quantity_variation += subgroup.quantity
    end
    self.variation.update(variation_quantity: total_quantity_variation)
  end
end
