FactoryBot.define do
  factory :admin do
    email { 'admin@admin.com'}
    password { '123456' }
    password_confirmation { '123456' }
  end

  factory :customer do
    name { 'Roger' }
    
    association :admin

    trait :with_cpf do
      cpf { '937.538.070-01' }
    end
  end
end
