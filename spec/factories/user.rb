FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Devise.friendly_token(10) }

    trait :with_bank_account do
      after(:create) do |user|
        user.create_bank_account!(amount: 1000, currency: Rails.application.config.default_currency_iso)
      end
    end

  end
end