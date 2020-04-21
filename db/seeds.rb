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
  
  # user_1 projects
  3.times do |n| 
    Project.create(name: "Project#{n}", user: user_1)
    Project.create(name: "Project#{n + 3}", user: user_2)
  end
  
  user_1.projects.each do |project|
    5.times do |n|
      Bug.create(description: "bug #{n} for #{project.name}", 
                 project: project,
                 user: user_1)
    end
  end
    
  user_2.projects.each do |project|
    4.times do |n|
      Bug.create(description: "bug #{n} for #{project.name}", 
                 project: project,
                 user: user_2)
    end
  end
    
end