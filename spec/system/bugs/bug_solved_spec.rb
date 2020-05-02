require "rails_helper"

RSpec.describe "Bug solved status", type: :system do
  
  let(:user) { create(:user) }
  let(:user_two) { create(:user) } 
  let(:user_three) { create(:user) } 
  
  let!(:project) { create(:project, user: user) }
  let!(:project_with_team) { create(:project, description: "Project with team",
                                              user: user_two,
                                              allowed_users: [user, user_three]) }
  let!(:bug_from_team_U) { create(:bug, description: "Bug from team",
                                        project: project_with_team,
                                        user: user,
                                        solved: false) }
                                        
  let!(:bug_from_team_S) { create(:bug, description: "Bug from team",
                                        project: project_with_team,
                                        user: user,
                                        solved: true) }
                                        
  
  let!(:bug_unsolved) { create(:bug, description: "Bug description to solve",
                            project: project, user: user,
                            solved: false) }
  let!(:bug_solved) { create(:bug, description: "Bug description to unsolve",
                            project: project, user: user,
                            solved: true) }
                            
                            
  
  it "can be set to solved by a logged in user that owns it" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_selector("#update-bug-solved-#{bug_unsolved.id}")
    expect(bug_unsolved.solved).to be_falsy
    page.find("#update-bug-solved-#{bug_unsolved.id}").click
    bug_unsolved.reload
    expect(bug_unsolved.solved).to be_truthy
  end
  
  it "can be set to unsolved by a logged in user that owns it" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_selector("#update-bug-solved-#{bug_solved.id}")
    expect(bug_solved.solved).to be_truthy
    page.find("#update-bug-solved-#{bug_solved.id}").click
    bug_solved.reload
    expect(bug_solved.solved).to be_falsy
  end
  
  it "of another user can be set to solve if you are owner of the project" do
    sign_in(user_two)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_selector("#update-bug-solved-#{bug_from_team_U.id}")
    expect(bug_from_team_U.solved).to be_falsy
    page.find("#update-bug-solved-#{bug_from_team_U.id}").click
    bug_from_team_U.reload
    expect(bug_from_team_U.solved).to be_truthy
  end
  
  it "of another user can't be set to solve you are not owner of the project" do
    sign_in(user_three)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_text(bug_from_team_U.description)
    expect(bug_from_team_U.solved).to be_falsy
    expect(page).not_to have_selector("#update-bug-solved-#{bug_from_team_U.id}")
  end
  
  it "of another user can be set to unsolved if you are owner of the project" do
    sign_in(user_two)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_selector("#update-bug-solved-#{bug_from_team_S.id}")
    expect(bug_from_team_S.solved).to be_truthy
    page.find("#update-bug-solved-#{bug_from_team_S.id}").click
    bug_from_team_S.reload
    expect(bug_from_team_S.solved).to be_falsy
  end
  
  it "of another user can't be set to unsolved you are not owner of the project" do
    sign_in(user_three)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_text(bug_from_team_S.description)
    expect(bug_from_team_S.solved).to be_truthy
    expect(page).not_to have_selector("#update-bug-solved-#{bug_from_team_S.id}")
  end
  
end