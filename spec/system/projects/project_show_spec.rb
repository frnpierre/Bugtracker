require "rails_helper"

RSpec.describe "Project show", type: :system do 
  
  let(:user) { User.create(email: "test@example.com", password: "password") } 
  let(:project) { Project.create(name: "Testproject", user_id: user.id) }
  
  it "by a logged in user is possible via the index page" do 
    expect(project.user_id).to eq(user.id)
    visit projects_path
    expect(current_path).to eq(new_user_session_path)
    sign_in(user)
    visit projects_path
    expect(current_path).to eq(projects_path)
    expect(page).to have_text(project.name)
    click_link(project.name)
    expect(current_path).to eq(project_path(project))
  end
end