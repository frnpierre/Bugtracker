require "rails_helper"

RSpec.describe "Project creation", type: :system do
  
  let(:user) { create(:user) } 
  
  it "by a logged in user is possible" do
    projects_count = Project.count
    sign_in(user)
    visit new_project_path
    fill_in("project_name", with: "Project test name")
    fill_in("project_description", with: "Project test description")
    click_on("Create")
    expect(page).to have_selector(".alert-success")
    expect(current_path).to eq(projects_path)
    expect(Project.count).to eq(projects_count + 1)
    expect(Project.find_by(name: "Project test name")).to be_truthy
    expect(Project.find_by(description: "Project test description")).to be_truthy
  end
  
  it "is not accessible to a logged out user" do
    sign_in(user)
    sign_out(user)
    visit new_project_path
    expect(current_path).to eq(new_user_session_path)
  end
end