require "rails_helper"

RSpec.describe "TeamMembership creation", type: :system do
  
  let(:user) { create(:user) } 
  let(:user_two) { create(:user, username: "future_team_member",
                                 email: "future_team_member@example.com") }
  let!(:project) { create(:project, name: "Project membership",
                                   description: "Test project to test membership",
                                   user_id: user.id ) }
  let!(:project_with_team) { create(:project, description: "Project owned by user_two",
                                              user_id: user_two.id,
                                              allowed_users: [user]) }
  
  
  it "A logged in a user can add another user to his project team" do
    sign_in(user)
    visit project_path(project)
    expect(page).to have_link("Add user", href: new_project_team_membership_path(project))
    expect(current_path).to eq(project_path(project))
    expect(page).not_to have_text(user_two.username)
    click_on("Add user")
    expect(current_path).to eq(new_project_team_membership_path(project))
    expect(page).to have_text(user_two.username)
    click_on("Add")
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(user_two.username)
  end
  
  it "A logged in user can't add another user to a project he's in the team" do
    sign_in(user)
    visit project_path(project_with_team)
    expect(page).not_to have_link("Add user", href: new_project_team_membership_path(project_with_team))
  end
end