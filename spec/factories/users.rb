FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :with_organization do
      after(:build) do |user|
        user.organizations << create_list(:organization, 3)
      end

      before(:create) do |user|
        user.organizations << create_list(:organization, 3)
      end
    end
  end
end
