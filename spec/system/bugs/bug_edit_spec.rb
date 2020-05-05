require "rails_helper"

RSpec.describe "Bug edit", type: :system do 
  
  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let(:user_three) { create(:user) }
  
  let!(:project) { create(:project, user: user) }
  let!(:bug) { create(:bug, description: "Bug description to be edited",
                            project: project, user: user) }
  
  
  let!(:project_with_team) { create(:project, description: "Project with team",
                                              user: user_two,
                                              allowed_users: [user, user_three]) }
  let!(:bug_from_team) { create(:bug, description: "Bug from team",
                                      project: project_with_team,
                                      user: user) }


  it "by a logged in user is possible" do
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(bug.description)
    find("a[href='#{edit_project_bug_path(project, bug)}']").click
    expect(current_path).to eq(edit_project_bug_path(project, bug))
    fill_in("bug_name", with: "Edited bug name")
    fill_in("bug_description", with: "Edited bug description")
    click_on("Save changes")
    expect(current_path).to eq(project_path(project))
    expect(page).not_to have_text(bug.description)
    expect(page).to have_text("Edited bug name")
    expect(page).to have_text("Edited bug description")
  end
  
  it "is not accessible to a logged out user" do 
    sign_in(user)
    sign_out(user)
    visit edit_project_bug_path(project, bug)
    expect(current_path).to eq(new_user_session_path)
  end
  
  it "is not accessible if you don't own the project or the bug" do
    sign_in(user_three)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_text(bug_from_team.description)
    expect(page).not_to have_link("Edit", href: edit_project_bug_path(project_with_team, bug_from_team))
    visit edit_project_bug_path(project_with_team, bug_from_team)
    expect(current_path).to eq(root_path)
  end
end