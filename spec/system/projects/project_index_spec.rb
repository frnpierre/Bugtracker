require "rails_helper"

RSpec.describe "Project index", type: :system do 
  
  let(:user) { create(:user) }
  let!(:project_one) { create(:project, name: "Project one", user: user) } 
  let!(:project_two) { create(:project, name: "Project two", user: user) } 
  
  let(:user_two) { create(:user) } 
  let!(:project_other) { create(:project, name: "Project of user two", 
                                          user: user_two ) } 
  
  let!(:project_with_team) { create(:project, name: "Project with user in his team", 
                                             user: user_two,
                                             allowed_users: [user]) } 
  
  
  it "lists the current user projects" do 
    sign_in(user)
    visit projects_path
    expect(current_path).to eq(projects_path)
    # title links
    expect(page).to have_link(project_one.name, href: project_path(project_one))
    expect(page).to have_link(project_two.name, href: project_path(project_two))
    # show links
    expect(page).to have_link("Show", href: project_path(project_one))
    expect(page).to have_link("Show", href: project_path(project_two))
    # edit links
    expect(page).to have_link("Edit", href: edit_project_path(project_one))
    expect(page).to have_link("Edit", href: edit_project_path(project_two))
    # delete links
    expect(page).to have_link("Delete", href: project_path(project_one))
    expect(page).to have_link("Delete", href: project_path(project_two))
    
  end
  
  it "lists the projects you are part of the team" do
    sign_in(user)
    visit projects_path
    expect(current_path).to eq(projects_path)
    # title link
    expect(page).to have_link(project_with_team.name, href: project_path(project_with_team))
    # show links
    expect(page).to have_link("Show", href: project_path(project_with_team))
    # no edit links
    expect(page).not_to have_link("Edit", href: edit_project_path(project_with_team))
    # no delete links
    expect(page).not_to have_link("Delete", href: project_path(project_with_team))
  end
  
  it "doesn't list other users' projects if not part of the team" do 
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