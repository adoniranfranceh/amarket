require 'rails_helper'

RSpec.describe Customer, type: :model do
  describe 'CPF validation' do
    it "is valid with a valid CPF" do
      admin = FactoryBot.create(:admin)
      customer = FactoryBot.create(:customer, :with_cpf, admin: admin)
      expect(customer).to be_valid
    end

    it 'is invalid with an invalid CPF' do
      admin = FactoryBot.create(:admin)
      customer = FactoryBot.build(:customer, cpf: '12345678910', admin: admin)
      expect(customer).not_to be_valid
    end

    it 'is invalid with CPF consisting of repeating digits' do
      admin = FactoryBot.create(:admin)
      customer = FactoryBot.build(:customer, cpf: '111.111.111-11', admin: admin)
      expect(customer).not_to be_valid
    end
  end
end
