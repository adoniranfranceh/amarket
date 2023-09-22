class Customer < ApplicationRecord
  belongs_to :admin
  validates :name, presence: true


  scope :search, -> (term) {
    return all unless term.present?
    where("LOWER(name) LIKE ? OR LOWER(cpf) LIKE ? OR LOWER(phone) LIKE ? OR LOWER(email) LIKE ?", "%#{term.downcase}%", "%#{term.downcase}%", "%#{term.downcase}%", "%#{term.downcase}%")
  }
  scope :search_by_date, -> (date) {
    return all unless date.present?
    where("DATE(date_of_birth) = ?", date)
  }

  def cpf=(value)
    self[:cpf] = value.gsub(/\D/, '')
  end

  include CpfValidatable
end
