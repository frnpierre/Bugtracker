require "rails_helper"

RSpec.describe "TeamMembership destroy", type: :system do
  
  let(:user) { create(:user) } 
  let(:user_two) { create(:user, username: "team_member",
                                 email: "team_member@example.com") }
  let(:user_three) { create(:user, username: "team_member can't remove") }
  
  let!(:project) { create(:project, name: "Project membership",
                                    description: "Test project to test membership",
                                    user_id: user.id ) }
                                    
  let!(:team_membership) { TeamMembership.create(user_id: user_two.id, project_id: project.id) } 
  
  # project created by user two, with team: user, user_three 
  let!(:project_with_team) {  create(:project, description: "project owned by user_two",
                                               user_id: user_two.id,
                                               allowed_users: [user, user_three] ) }
  
  it "A logged in a user can remove another user from his project team" do
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(user_two.email)
    expect(page).to have_link("remove", href: project_team_membership_path(project, team_membership))
    click_on("remove")
    expect { team_membership.reload }.to raise_error ActiveRecord::RecordNotFound
    expect(current_path).to eq(project_path(project))
    expect(page).not_to have_text(user_two.email)
  end
  
  it "A logged in user can't remove another user to a project he's in the team" do
    sign_in(user)
    visit project_path(project_with_team)
    membership = TeamMembership.find_by(user_id: user_three.id, project_id: project_with_team.id)
    expect(page).not_to have_link("remove", href: project_team_membership_path(project_with_team, membership))
  end
end