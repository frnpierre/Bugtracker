require "rails_helper" 

RSpec.describe "Comment creation", type: :system do 
  
  let(:user) { create(:user) } 
  let!(:project) { create(:project, user_id: user.id) } 
  let!(:bug) { create(:bug, user_id: user.id, project_id: project.id,
                           name: "Bug name to be commented",
                           description: "Bug description to be commented") }
  
  it "by a logged in user is possible via project show page" do 
    sign_in(user)
    visit project_path(project)
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text(bug.name)
    fill_in("bug-#{bug.id}-comment-content", with: "Comment content")
    click_on("Comment")
    expect(current_path).to eq(project_path(project))
    expect(page).to have_text("Comment content")
  end
end