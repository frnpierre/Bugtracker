require "rails_helper" 

RSpec.describe "Bug creation", type: :system do 
  
  let(:user) { create(:user) } 
  let(:project) { create(:project, user_id: user.id) } 
  
  it "by a logged in user is possible" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(project.name)
    click_on("Report Bug")
    expect(current_path).to eq(new_project_bug_path(project))
    expect(project.bugs.count).to eq(0)
    fill_in("bug_description", with: "Test bug report n1")
    click_on("Report")
    expect(project.bugs.count).to eq(1)
    expect(page).to have_selector(".alert-success")
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text("Test bug report n1")
  end
end