FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }

    trait :with_organization do
      after(:build) do |user|
        user.organizations << create_list(:organization, 3)
      end
    end
  end
end
