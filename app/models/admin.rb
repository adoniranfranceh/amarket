class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :customers
  has_many :categories
  has_many :products
  has_many :sales
  has_many :secondaryproducts
  has_many :cash
  before_save :create_cash

  def create_cash
    return if cash.present?
    self.cash.build(cash_name: "Caixa do #{email}", is_open: false)
  end
end
