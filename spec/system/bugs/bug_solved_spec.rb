require "rails_helper"

RSpec.describe "Bug solved status", type: :system do
  
  let(:user) { create(:user) }
  let!(:project) { create(:project, user: user) }
  let!(:bug_unsolved) { create(:bug, description: "Bug description to solve",
                            project: project, user: user,
                            solved: false) }
  let!(:bug_solved) { create(:bug, description: "Bug description to unsolve",
                            project: project, user: user,
                            solved: true) }
  
  it "can be set to solved by a logged in user" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_selector("#update-bug-solved-#{bug_unsolved.id}")
    expect(bug_unsolved.solved).to be_falsy
    page.find("#update-bug-solved-#{bug_unsolved.id}").click
    bug_unsolved.reload
    expect(bug_unsolved.solved).to be_truthy
  end
  
  it "can be set to unsolved by a logged in user" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_selector("#update-bug-solved-#{bug_solved.id}")
    expect(bug_solved.solved).to be_truthy
    page.find("#update-bug-solved-#{bug_solved.id}").click
    bug_solved.reload
    expect(bug_solved.solved).to be_falsy
  end
end