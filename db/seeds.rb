# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Rails.env.development? 
  
  user_1 = User.create(username: "User-one", email: "test@example.com", password: "password")
  user_2 = User.create(username: "User-two", email: "test2@example.com", password: "password")
  
  10.times do |n|
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
    # random 3 allowed users ids array
    allowed_users_arr = (2..10).to_a.sample(3)
    
    # team memberships for this project
    allowed_users_arr.each do |allowed_user| 
      TeamMembership.create(project_id: project.id, user_id: allowed_user)
    end
    
    # At least one unsolved bug by owner
    Bug.create(name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                description: Faker::Lorem.paragraph, 
                project: project,
                user: user_1,
                solved: false)
                
    # 2 Unsolved bugs by random team members
    2.times do |n|
      Bug.create( name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                  description: Faker::Lorem.paragraph, 
                  project: project,
                  user: project.allowed_users.sample,
                  solved: false)
    end
    
    # 2 Solved bugs by random team members
    2.times do |n|
      Bug.create( name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                  description: Faker::Lorem.paragraph, 
                  project: project,
                  user: project.allowed_users.sample,
                  solved: true)
    end
  end
    
  user_2.projects.each do |project|
    # random 3 allowed users array
    allowed_users_arr = (3..10).to_a.sample(3)
    
    # team memberships for this project
    allowed_users_arr.each do |allowed_user| 
      TeamMembership.create(project_id: project.id, user_id: allowed_user)
    end
    
    # At least one unsolved bug by owner
    Bug.create(name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                description: Faker::Lorem.paragraph, 
                project: project,
                user: user_2,
                solved: false)
                  
    # random solved/unsolved bugs by random team members
    5.times do |n|
      Bug.create(name: Faker::Lorem.words(number: rand(1..4)).join(" ").capitalize,
                  description: Faker::Lorem.paragraph, 
                  project: project,
                  user: project.allowed_users.sample,
                  solved: [true, false].sample)
    end
  end
  
  
  # Random number of comments on all bugs, by random team members
  Bug.all.each do |bug|
    n_comments = rand(1..4)
    n_comments.times do |n|
      Comment.create( content: Faker::Lorem.paragraph,
                        user_id: bug.project.allowed_users.sample.id,
                        bug_id: bug.id)
    end
    
  end
end