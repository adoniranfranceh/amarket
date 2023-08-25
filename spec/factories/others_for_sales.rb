FactoryBot.define do
  factory :others_for_sale do
    payment_method { "MyString" }
    other_value { 1.5 }
    sale { nil }
  end
end
