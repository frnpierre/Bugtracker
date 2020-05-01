require "rails_helper"

RSpec.describe "Bug edit", type: :system do 
  
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:bug) { create(:bug, description: "Bug description to be edited",
                            project: project, user: user) }

  it "by a logged in user is possible" do
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(bug.description)
    find("a[href='#{edit_project_bug_path(project, bug)}']").click
    expect(current_path).to eq(edit_project_bug_path(project, bug))
    fill_in("bug_description", with: "Edited bug description")
    click_on("Save changes")
    expect(current_path).to eq(project_path(project))
    expect(page).not_to have_text(bug.description)
    expect(page).to have_text("Edited bug description")
  end
  
  it "is not accessible to a logged out user" do 
    sign_in(user)
    sign_out(user)
    visit edit_project_bug_path(project, bug)
    expect(current_path).to eq(new_user_session_path)
  end
end