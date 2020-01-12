require "rails_helper"

RSpec.describe "user authentication", type: :system do 
  
  let(:user) { User.create(email: "test@example.com", password: "password") }
  
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
end