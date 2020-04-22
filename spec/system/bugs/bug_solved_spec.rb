require "rails_helper"

RSpec.describe "Bug solved status", type: :system do
  
  let(:user) { create(:user) }
  let!(:project) { create(:project, user_id: user.id) }
  let!(:bug) { create(:bug, description: "Bug description to change solved status",
                            project_id: project.id, user_id: user.id) }
                            
  
  xit "can be set to solved by a logged in user" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_selector("#solve-bug-#{bug.id}")
    page.find("#solve-bug-#{bug.id}").click
    bug.reload
    expect(bug.solved).to be_truthy
  end
end