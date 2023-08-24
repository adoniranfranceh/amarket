class Customer < ApplicationRecord
  belongs_to :admin
  validates :name, presence: true

  def cpf=(value)
    self[:cpf] = value.gsub(/\D/, '')
  end

  include CpfValidatable
end
