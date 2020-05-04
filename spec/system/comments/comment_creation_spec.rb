require "rails_helper" 

RSpec.describe "Comment creation", type: :system do 
  
  let(:user) { create(:user) } 
  let(:user_two) { create(:user) }
  let(:user_without_team) { create(:user) }
  
  let!(:project) { create(:project, user: user) } 
  let!(:bug) { create(:bug, user: user, project: project,
                            name: "Bug name to be commented",
                            description: "Bug description to be commented") }
  
  
  let!(:project_with_team) { create(:project, description: "Project with team",
                                              user: user_two,
                                              allowed_users: [user]) }
  
  let!(:bug_on_pwt) { create(:bug, user: user_two, project: project_with_team,
                                   name: "Bug on project with team",
                                   description: "Bug on pwt to be commented") }
  
  
  
  it "by a logged in user is possible via project show page on a project you own" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(bug.name)
    expect(page).to have_selector("#bug-#{bug.id}-comment-content")
    fill_in("bug-#{bug.id}-comment-content", with: "Comment content")
    click_on("Comment")
    expect(current_path).to eq(project_path(project))
    bug.reload
    expect(bug.comments.last.content).to eq("Comment content")
    expect(page).to have_text("Comment content")
  end
  
  it "is possible on a project you're part of the team" do 
    sign_in(user)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_text(bug_on_pwt.name)
    expect(page).to have_selector("#bug-#{bug_on_pwt.id}-comment-content")
    fill_in("bug-#{bug_on_pwt.id}-comment-content", with: "Comment content")
    click_on("Comment")
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_text("Comment content")
    bug_on_pwt.reload
    expect(bug_on_pwt.comments.last.content).to eq("Comment content")
  end
  
  it "is not accessible on a project you're not part of the team" do 
    sign_in(user_without_team)
    visit project_path(project_with_team)
    expect(current_path).to eq(root_path)
    expect(page).not_to have_selector("#bug-#{bug_on_pwt.id}-comment-content")
  end
end