require "rails_helper"

RSpec.describe "Project index", type: :system do 
  
  let(:user) { create(:user) }
  let!(:project_one) { create(:project, name: "Project one", user_id: user.id) } 
  let!(:project_two) { create(:project, name: "Project two", user_id: user.id) } 
  
  let(:user_two) { create(:user) } 
  let!(:project_other) { create(:project, name: "Project of user two", 
                                          user_id: user_two.id ) } 
  
  it "lists the current user projects" do 
    sign_in(user)
    visit projects_path
    expect(current_path).to eq(projects_path)
    expect(page).to have_link(project_one.name, href: project_path(project_one))
    expect(page).to have_link(project_two.name, href: project_path(project_two))
  end
  
  it "doesn't list other users' projects" do 
    sign_in(user)
    visit projects_path
    expect(current_path).to eq(projects_path)
    expect(page).not_to have_link(project_other.name, href: project_path(project_other))
  end
  
  it "is not accessible to a logged out user" do 
    visit projects_path 
    expect(current_path).to eq(new_user_session_path)
  end
end