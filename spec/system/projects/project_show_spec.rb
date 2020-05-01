require "rails_helper"

RSpec.describe "Project show", type: :system do 
  
  let(:user) { create(:user) } 
  let!(:project) { create(:project, name: "Project of user one", 
                                    user: user) }
  
  
  let(:user_two) { create(:user) } 
  let!(:project_two) { create(:project, name: "Project of user two", 
                                        user: user_two ) } 
  
  let!(:project_with_team) { create(:project, name: "Project with user in his team", 
                                              user: user_two,
                                              allowed_users: [user]) } 
  
  
  # For a project you own
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
  
  it "is possible if you are part of the team" do
    sign_in(user)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
  end
  
  it "is not possible if it is not your project & you're not in the team" do 
    sign_in(user)
    visit project_path(project_two)
    expect(current_path).to eq(root_path)
  end
  
  it "is not accessible to a logged out user" do 
    sign_in(user)
    sign_out(user)
    visit project_path(project)
    expect(current_path).to eq(new_user_session_path)
  end
end