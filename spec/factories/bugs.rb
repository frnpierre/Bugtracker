FactoryBot.define do 
  factory :bug do 
    sequence(:name) { |n| "Bug name #{n}" }
    sequence(:description) { |n| "Bug description #{n}" }
  end
end