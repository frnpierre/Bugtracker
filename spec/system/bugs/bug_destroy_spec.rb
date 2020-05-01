require "rails_helper"

RSpec.describe "Bug destroy", type: :system do 
  
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:bug) { create(:bug, description: "Bug description to destroy",
                            project: project, user: user) }

  it "by a logged in user is possible" do
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
end