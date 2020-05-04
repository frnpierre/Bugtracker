require "rails_helper"

RSpec.describe "Comments requests", type: :request do 
  
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
                            user: user) }
                            
  let!(:bug_from_team) { create(:bug, description: "Requests tests bug",
                                      project: project_with_team,
                                      user: user_two ) }
  
  context "For a logged in user" do 
    
    it "can access create for a project you own" do 
      sign_in(user)
      post(comments_url, params: { comment: {
                                             project_id: project.id,
                                             bug_id: bug.id,
                                             content: "Accepted comment content"
                                            }
      })
      expect(Comment.find_by(content: "Accepted comment content")).not_to be_nil
    end
    
  end
  
  
  context "For a logged out user" do 
    
    it "can't access create" do 
      post(comments_url, params: { comment: {
                                             project_id: project.id,
                                             bug_id: bug.id,
                                             content: "Rejected comment content"
                                            }
      })
      expect(request).to redirect_to(new_user_session_path)
      expect(Bug.find_by(description: "Rejected comment content")).to be_nil
      
    end

  end
  
  context "Authorization" do
   
    it "can access create if you are part of the team" do
      sign_in(user)
      post(comments_url, params: { comment: {
                                             project_id: project_with_team.id,
                                             bug_id: bug_from_team.id,
                                             content: "Accepted comment content"
                                            }
      })
      expect(Comment.find_by(content: "Accepted comment content")).not_to be_nil
    end
    
    it "can't access create if you are not in the team" do
      sign_in(user_without_team)
      post(comments_url, params: { comment: {
                                             project_id: project_with_team.id,
                                             bug_id: bug_from_team.id,
                                             content: "Rejected comment content"
                                            }
      })
      expect(request).to redirect_to(root_url)
      expect(Comment.find_by(content: "Rejected comment content")).to be_nil
    end
  end
end