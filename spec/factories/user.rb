FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "TEST#{n}@example.com" }
    password { 'password' }
  end
end
