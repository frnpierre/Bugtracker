# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development? 
  
  user_1 = User.create(email: "test@example.com", password: "password")
  user_2 = User.create(email: "test2@example.com", password: "password")
  
  20.times do |n|
    user_name = Faker::Internet.user_name(separators: "")
    User.create(username: user_name,
                  email: user_name + "@example.com",
                  password: "password")
    end
  
  
  3.times do |n| 
    Project.create(name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                    description: Faker::Lorem.paragraph,
                    user: user_1)
    Project.create(name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                    description: Faker::Lorem.paragraph,
                    user: user_2)
  end
  
  user_1.projects.each do |project|
    5.times do |n|
      Bug.create(name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                  description: Faker::Lorem.paragraph, 
                  project: project,
                  
                  user: user_1)
    end
  end
    
  user_2.projects.each do |project|
    4.times do |n|
      Bug.create( name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                  description: Faker::Lorem.paragraph, 
                  project: project,
                  user: user_2)
    end
  end
  
  Bug.all.each do |bug|
    n_comments = rand(0..3)
    n_comments.times do |n|
      Comment.create( content: Faker::Lorem.paragraph,
                        user_id: rand(1..4),
                        bug_id: bug.id)
    end
    
  end
end