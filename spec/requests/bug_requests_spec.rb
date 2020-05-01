require "rails_helper"

RSpec.describe "Bugs requests", type: :request do 
  
  let(:user) { create(:user) }
  let!(:project) { create(:project, name: "Requests tests project",
                                    user: user) }
  let!(:bug) { create(:bug, description: "Requests tests bug",
                            project: project,
                            user: user ) }
  
  context "For a logged in user" do 
    
    before(:each) do 
      sign_in(user)
    end
    
    it "can access new" do 
      get new_project_bug_url(project)
      expect(response).to have_http_status(200)
    end
    
    it "can access edit" do 
      get edit_project_bug_url(project, bug)
      expect(response).to have_http_status(200)
    end
    
    it "can access create" do 
      post(project_bugs_url(project), params: { bug: 
                                        { description: "Accepted bug" }})
      expect(Bug.find_by(description: "Accepted bug")).not_to be_nil
    end
    
    it "can access update" do
      patch(project_bug_url(project, bug), params: { bug: 
                                            { description: "Accepted bug edited" }})
      bug.reload                                            
      expect(bug).to have_attributes(description: "Accepted bug edited")
    end
    
    it "can access destroy" do 
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
end