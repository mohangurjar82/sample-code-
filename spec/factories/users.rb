FactoryGirl.define do
  factory :user do
    sequence(:email){|n| "person#{n}@example.com"}
    password 'good_password'
  end
end
