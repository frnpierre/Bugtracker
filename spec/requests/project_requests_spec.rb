require "rails_helper"

RSpec.describe "Projects requests", type: :request do 
  
  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let!(:project) { create(:project, name: "Requests tests project",
                                    user_id: user.id) }
  let!(:project_two) { create(:project, name: "RT project two",
                                       user_id: user_two.id ) }
    
  
  context "For a logged in user" do 
    
    before(:each) do 
      sign_in(user)
    end
    
    it "can access index" do 
      get projects_url
      expect(response).to have_http_status(200)
    end
    
    it "can access show" do 
      get project_url(project)
      expect(response).to have_http_status(200)
    end
    
    it "can access new" do 
      get new_project_url
      expect(response).to have_http_status(200)
    end
    
    it "can access edit" do 
      get edit_project_url(project)
      expect(response).to have_http_status(200)
    end
    
    it "can access create" do 
      post(projects_url, params: { project: 
                          { name: "Accepted project" }})
      expect(Project.find_by(name: "Accepted project")).not_to be_nil
    end
    
    it "can access update" do 
      patch(project_url(project), params: { project: 
                                    { name: "Accepted edited project" }})
      project.reload
      expect(project).to have_attributes(name: "Accepted edited project")
    end
    
    it "can access destroy" do 
      expect { delete(project_url(project)) }.to change { Project.count }.by(-1)
    end
  end
  
  
  context "For a logged out user" do 
    
    it "can't access index" do 
      get projects_url
      expect(request).to redirect_to(new_user_session_path)
    end
    
    it "can't access show" do 
      get project_url(project)
      expect(request).to redirect_to(new_user_session_path)
    end
    
    it "can't access new" do 
      get new_project_url
      expect(request).to redirect_to(new_user_session_path)
    end
    
    it "can't access edit" do 
      get edit_project_url(project)
      expect(request).to redirect_to(new_user_session_path)
    end
    
    it "can't access create" do 
      post(projects_url, params: { project: 
                          { name: "Rejected project" }})
      expect(request).to redirect_to(new_user_session_path)
      expect(Project.find_by(name: "Rejected project")).to be_nil
    end
    
    it "can't access update" do 
      patch(project_url(project), params: { project: 
                                    { name: "Rejected edited project" }})
      expect(request).to redirect_to(new_user_session_path)
      project.reload
      expect(project).not_to have_attributes(name: "Rejected edited project")
    end
    
    it "can't access destroy" do 
      delete(project_url(project))
      expect(request).to redirect_to(new_user_session_path)
      expect(Project.find_by(name: project.name)).not_to be_nil
    end
  end
  
  context "Authorization" do 
    
    before(:each) do 
      sign_in(user)
    end
    
    it "can't access another user's projects#show" do 
      get project_url(project_two)
      expect(request).to redirect_to(root_url)
    end
    
    it "can't access another user's projects#edit" do 
      get edit_project_url(project_two)
      expect(request).to redirect_to(root_url)
    end
    
    it "can't update another user's project" do 
      patch(project_url(project_two), params: { project: 
                                    { name: "Rejected edited project" }})
      expect(request).to redirect_to(root_url)
      expect(Project.find_by(name: "Rejected edited project")).to be_nil
    end
    
    it "can't destroy another user's project" do 
      delete(project_url(project_two))
      expect(request).to redirect_to(root_url)
      expect(Project.find_by(name: project_two.name)).not_to be_nil
    end
  end
end