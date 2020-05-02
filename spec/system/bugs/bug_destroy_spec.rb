require "rails_helper"

RSpec.describe "Bug destroy", type: :system do 
  
  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let(:user_three) { create(:user) }
  
  let!(:project) { create(:project, user: user) }
  let!(:bug) { create(:bug, description: "Bug description to destroy",
                            project: project, user: user) }

  let!(:project_with_team) { create(:project, description: "Project with team",
                                              user: user_two,
                                              allowed_users: [user, user_three]) }
  let!(:bug_from_team) { create(:bug, description: "Bug from team",
                                      project: project_with_team,
                                      user: user) }


  it "by a logged in user that owns it is possible" do
    bug_count = Bug.count
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_selector("#delete-bug-#{bug.id}")
    page.find("#delete-bug-#{bug.id}").click 
    expect(Bug.count).to eq(bug_count - 1)
    expect(current_path).to eq(project_path(project))
    expect(page).not_to have_selector("#delete-bug-#{project.id}")
    expect(page).not_to have_text(bug.description)
  end
  
  it "is not accessible if you don't own the project or the bug" do
    sign_in(user_three)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_text(bug_from_team.description)
    expect(page).not_to have_selector("#delete-bug-#{bug_from_team.id}")
  end
end