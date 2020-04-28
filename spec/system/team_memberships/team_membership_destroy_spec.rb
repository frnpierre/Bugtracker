require "rails_helper"

RSpec.describe "TeamMembership destroy", type: :system do
  
  let(:user) { create(:user) } 
  let(:user_two) { create(:user, username: "team_member",
                                 email: "team_member@example.com") }
  let!(:project) { create(:project, name: "Project membership",
                                   description: "Test project to test membership",
                                   user_id: user.id ) }
  let!(:team_membership) { TeamMembership.create(user_id: user_two.id, project_id: project.id) } 
  
  it "A logged in a user can remove another user from his project team" do
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(user_two.email)
    click_on("remove")
    expect { team_membership.reload }.to raise_error ActiveRecord::RecordNotFound
    expect(current_path).to eq(project_path(project))
    expect(page).not_to have_text(user_two.email)
  end
end