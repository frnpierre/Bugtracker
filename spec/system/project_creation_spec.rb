require "rails_helper"

RSpec.describe "Project creation", type: :system do

  let(:user) { User.create(email: "test@example.com", password: "password") }
  
  it "by a logged in user is possible" do
    projects_count = Project.count
    sign_in(user)
    visit new_project_path
    fill_in("project_name", with: "Project test name")
    click_on("Create")
    expect(page).to have_selector(".alert-success")
    expect(Project.count).to eq(projects_count + 1)
  end
  
  it "by a logged out user is NOT possible" do
    sign_in(user)
    sign_out(user)
    visit new_project_path
    expect(current_path).to eq(new_user_session_path)
  end
  
end