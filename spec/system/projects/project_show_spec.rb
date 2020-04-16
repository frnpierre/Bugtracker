require "rails_helper"

RSpec.describe "Project show", type: :system do 
  
  let(:user) { create(:user) } 
  let!(:project) { create(:project, user_id: user.id) }
  
  it "by a logged in user is possible via the index page" do 
    visit projects_path
    expect(current_path).to eq(new_user_session_path)
    sign_in(user)
    visit projects_path
    expect(current_path).to eq(projects_path)
    expect(page).to have_text(project.name)
    click_link(project.name)
    expect(current_path).to eq(project_path(project))
  end
  
  it "is not accessible to a logged out user" do 
    sign_in(user)
    sign_out(user)
    visit project_path(project)
    expect(current_path).to eq(new_user_session_path)
  end
end