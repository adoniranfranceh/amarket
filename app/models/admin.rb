class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :email, presence: true 
  has_many :customers
  has_many :categories
  has_many :products
  has_many :sales
  has_many :secondaryproducts
  has_many :cash
  has_one :profile_admin
  has_one_attached :avatar
  accepts_nested_attributes_for :profile_admin
  before_create :create_cash_and_blank_profile

  def image_url
    if avatar.attached?
      avatar.url
    else
      'assets/no_image.png'
    end
  end

  def full_name_admin
    "#{self.profile_admin.first_name} #{self.profile_admin.last_name}"
  end

  private

  def create_cash_and_blank_profile
    return if cash.present?
    self.cash.build(cash_name: "Caixa do #{email}", is_open: false)
    if self.profile_admin.nil?
      parts = email.split('@')
      self.build_profile_admin(first_name: parts[0], last_name: '')
    end
  end
end
