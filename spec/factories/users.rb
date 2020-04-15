FactoryBot.define do 
  factory :user do 
    sequence(:email) { |n| "testuser-#{n}@example.com" } 
    password { "password" } 
  end
end