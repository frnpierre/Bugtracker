require "rails_helper"

RSpec.describe "Project destroy", type: :system do 
  
  let(:user) { User.create(email: "test@example.com", password: "password") }
  let(:project) { Project.create(name: "Testproject", user_id: user.id) }
  
  it "by a logged in user is possible via the index page" do 
    project_id = project.id
    project_count = Project.count
    sign_in(user)
    visit projects_path
    expect(current_path).to eq(projects_path)
    expect(page).to have_selector("#project-#{project_id}")
    page.find("#project-#{project_id}").click
    expect(Project.count).to eq(project_count - 1)
    expect(current_path).to eq(projects_path)
    expect(page).not_to have_selector("#project-#{project_id}")
  end
end