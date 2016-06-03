FactoryGirl.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }
    # sequence(:email){|n| "person#{n}@example.com"}
    # password 'good_password'
  end
end
