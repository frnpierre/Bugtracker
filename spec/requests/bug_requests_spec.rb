require "rails_helper"

RSpec.describe "Bugs requests", type: :request do 
  
  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let(:user_without_team) { create(:user) }
  
  let!(:project) { create(:project, name: "Requests tests project",
                                    user: user) }
  let!(:project_with_team) { create(:project, name: "Project with user in the team",
                                             user: user_two,
                                             allowed_users: [user]) }
                                             
  let!(:bug) { create(:bug, description: "Requests tests bug",
                            project: project,
                            user: user ) }
  
  context "For a logged in user" do 
    
    before(:each) do 
      sign_in(user)
    end
    
    it "can access new for a project you own" do 
      get new_project_bug_url(project)
      expect(response).to have_http_status(200)
    end
    
    it "can access edit for a project you own" do 
      get edit_project_bug_url(project, bug)
      expect(response).to have_http_status(200)
    end
    
    it "can access create for a project you own" do 
      post(project_bugs_url(project), params: { bug: 
                                        { description: "Accepted bug" }})
      expect(Bug.find_by(description: "Accepted bug")).not_to be_nil
    end
    
    it "can access update for a project you own" do
      patch(project_bug_url(project, bug), params: { bug: 
                                            { description: "Accepted bug edited" }})
      bug.reload                                            
      expect(bug).to have_attributes(description: "Accepted bug edited")
    end
    
    it "can access destroy for a project you own" do 
      expect { delete(project_bug_url(project, bug)) }.to change { Bug.count }.by(-1)
    end
  end
  
  
  context "For a logged out user" do 
    
    it "can't access new" do 
      get new_project_bug_url(project)
      expect(request).to redirect_to(new_user_session_path)
    end
    
    it "can't access edit" do 
      get edit_project_bug_url(project, bug)
      expect(request).to redirect_to(new_user_session_path)
    end
    
    it "can't access create" do 
      post(project_bugs_url(project), params: { bug: 
                                        { description: "Rejected bug" }})
      expect(request).to redirect_to(new_user_session_path)
      expect(Bug.find_by(description: "Rejected bug")).to be_nil
    end

    it "can't access update" do
      patch(project_bug_url(project, bug), params: { bug: 
                                            { description: "Rejected bug edited" }})
      expect(request).to redirect_to(new_user_session_path)
      bug.reload                                            
      expect(bug).not_to have_attributes(description: "Rejected bug edited")
    end
    
    it "can't access destroy" do 
      delete(project_bug_url(project, bug))
      expect(request).to redirect_to(new_user_session_path)
      expect(Bug.find_by(description: bug.description)).not_to be_nil
    end
  end
  
  context "Authorization" do
    
    it "can access new if you are part of the team" do
      sign_in(user)
      get new_project_bug_url(project_with_team)
      expect(response).to have_http_status(200)
    end
    
    it "can't access new if you are not in the team" do
      sign_in(user_without_team)
      get new_project_bug_url(project_with_team)
      expect(request).to redirect_to(root_url)
    end
    
    it "can access create if you are part of the team" do
      sign_in(user)
      post(project_bugs_url(project_with_team), params: { bug: 
                                        { description: "Accepted bug" }})
      expect(Bug.find_by(description: "Accepted bug")).not_to be_nil
    end
    
    it "can't access create if you are not in the team" do
      sign_in(user_without_team)
      post(project_bugs_url(project_with_team), params: { bug: 
                                        { description: "Rejected bug" }})
      expect(request).to redirect_to(root_url)
      expect(Bug.find_by(description: "Rejected bug")).to be_nil
    end
    
  end
end