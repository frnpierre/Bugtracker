require "rails_helper"

RSpec.describe "Project destroy", type: :system do 
  
  let(:user) { create(:user) } 
  let!(:project) { create(:project, user_id: user.id) } 
  
  it "by a logged in user is possible via the index page" do 
    project_count = Project.count
    sign_in(user)
    visit projects_path
    expect(current_path).to eq(projects_path)
    expect(page).to have_selector("#delete-project-#{project.id}")
    page.find("#delete-project-#{project.id}").click
    expect(Project.count).to eq(project_count - 1)
    expect(current_path).to eq(projects_path)
    expect(page).not_to have_selector("#delete-project-#{project.id}")
  end
end