require "rails_helper"

RSpec.describe "Project edit", type: :system do 
  
  let(:user) { create(:user) } 
  let(:project) { create(:project, user_id: user.id) }
  
  it "by a logged in user is possible via the index page" do 
    visit edit_project_path(project)
    expect(current_path).to eq(new_user_session_path)
    sign_in(user)
    visit projects_path
    find("a[href='#{edit_project_path(project)}']").click
    expect(current_path).to eq(edit_project_path(project))
    fill_in("project_name", with: "Edited Testproject")
    click_on("Save")
    expect(current_path).to eq(projects_path)
    expect(page).to have_selector(".alert-success")
    expect(page).to have_text("Edited Testproject")
  end
end