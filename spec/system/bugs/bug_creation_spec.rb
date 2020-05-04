require "rails_helper" 

RSpec.describe "Bug creation", type: :system do 
  
  let(:user) { create(:user) } 
  let(:user_two) { create(:user) }
  let(:user_without_team) { create(:user) }
  
  let(:project) { create(:project, user: user) } 
  let!(:project_with_team) { create(:project, description: "Project with team",
                                             user: user_two,
                                             allowed_users: [user]) }
  
  # on a project you own
  it "by a logged in user is possible via project show page" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(project.name)
    click_on("Report Bug")
    expect(current_path).to eq(new_project_bug_path(project))
    expect(project.bugs.count).to eq(0)
    fill_in("bug_name", with: "Test bug name")
    fill_in("bug_description", with: "Test bug report n1")
    click_on("Report")
    expect(project.bugs.count).to eq(1)
    expect(page).to have_selector(".alert-success")
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text("Test bug name")
    expect(page).to have_text("Test bug report n1")
  end
  
  it "is possible on a project you're part of the team" do
    sign_in(user)
    visit project_path(project_with_team)
    expect(current_path).to eq(project_path(project_with_team))
    click_on("Report Bug")
    expect(current_path). to eq(new_project_bug_path(project_with_team))
    expect(project_with_team.bugs.count).to eq(0)
    fill_in("bug_name", with: "Test bug team name")
    fill_in("bug_description", with: "Test bug team report n1")
    click_on("Report")
    expect(project_with_team.bugs.count).to eq(1)
    expect(page).to have_selector(".alert-success")
    expect(current_path).to eq(project_path(project_with_team))
    expect(page).to have_text("Test bug team name")
    expect(page).to have_text("Test bug team report n1")
  end
  
  it "is not possible on a project you're not part of the team" do 
    sign_in(user_without_team)
    visit new_project_bug_path(project_with_team)
    expect(current_path).to eq(root_path)
  end
  
end