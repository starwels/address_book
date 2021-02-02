FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }

    trait :as_admin do
      role { :admin }
    end

    trait :with_organization do
      after(:build) do |user|
        user.organizations << create(:organization)
      end

      before(:create) do |user|
        user.organizations << create(:organization)
      end
    end
  end
end
