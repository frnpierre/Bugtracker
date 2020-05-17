require "rails_helper"

RSpec.describe "user authentication", type: :system do 
  
  let!(:user) { create(:user, username: "First user") } 
  let!(:user_two) { create(:user, username: "Second user") }
  
  let!(:project_with_team) { create(:project, description: "Project with team",
                                              user: user,
                                              allowed_users: [user_two]) }
  
  it "login is possible with valid credentials" do 
    visit new_user_session_path
    expect(page).not_to have_selector(".logout-link")
    expect(page).to have_selector(".login-link")
    fill_in("user_email", with: user.email)
    fill_in("user_password", with: user.password)
    click_button("Log in")
    expect(current_path).to eq(root_path)
    expect(page).to have_selector(".logout-link")
    expect(page).not_to have_selector(".login-link")
  end
  
  it "login fails with invalid credentials" do 
    visit new_user_session_path
    expect(page).not_to have_selector(".logout-link")
    expect(page).to have_selector(".login-link")
    fill_in("user_email", with: "#{user.email}error")
    fill_in("user_password", with: "#{user.password}error")
    click_button("Log in")
    expect(current_path).to eq(new_user_session_path)
    expect(page).to have_selector(".login-link")
    expect(page).not_to have_selector(".logout-link")
  end
  
  it "Become user works from home page if logged out" do
    visit root_path
    expect(page).not_to have_selector(".logout-link")
    expect(page).to have_selector(".login-link")
    find("a[href='#{become_user_path(user.id)}']").click
    expect(page).to have_content("You logged in as #{user.username}")
    expect(page).to have_selector(".logout-link")
    expect(page).not_to have_selector(".login-link")
  end
  
  it "Become user works from home page if already logged in" do
    sign_in(user)
    visit root_path
    expect(page).to have_selector(".logout-link")
    expect(page).not_to have_selector(".login-link")
    find("a[href='#{become_user_path(user_two.id)}']").click
    expect(page).to have_content("You logged in as #{user_two.username}")
    expect(page).to have_selector(".logout-link")
    expect(page).not_to have_selector(".login-link")
  end
  
end