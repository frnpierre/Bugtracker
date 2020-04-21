FactoryBot.define do 
  factory :bug do 
    sequence(:description) { |n| "Bug description #{n}" }
  end
end