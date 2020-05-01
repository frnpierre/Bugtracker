require "rails_helper"

RSpec.describe "Team membership requests", type: :request do 
  
  let(:user) { create(:user) }
  let(:user_two) { create(:user) }
  let(:user_three) { create(:user) } 
  
  # projects without a team
    # that user owns
  let!(:project_one) { create(:project, name: "Project without a team owned by user",
                                        user: user ) }
    # that user doesn't own
  let!(:project_no_t) { create(:project, name: "Projet without a team that user doesn't own",
                                         user: user_two) }
                                          
  # projects with a team 
    # that user owns
  let!(:project_three) { create(:project, name: "Project with a team owned by user",
                                          user: user) }
    # that user doesn't owns
  let!(:project_two) { create(:project, name: "Project with a team that user doesn't own",
                                        user: user_two) }
                                    
  # memberships              
    # project that user owns has user_two in its team 
  let!(:membership_p_three) { TeamMembership.create(project: project_three, user: user_two ) }
    # project that user doesn't owns has user_three in its team
  let!(:membership_p_two) { TeamMembership.create(project: project_two, user: user_three ) }
  
  context "For a logged in user" do 
    
    before(:each) do 
      sign_in(user)
    end
    
    it "can access new on a project you own" do 
      get new_project_team_membership_url(project_one)
      expect(response).to have_http_status(200)
    end
    
    it "can access create on a project you own" do 
      expect(project_one.allowed_users).not_to include(user_two)
      post(project_team_memberships_url(project_one), params: { project_id: project_one.id,
                                                   user_id: user_two.id })
      expect(TeamMembership.find_by(user_id: user_two.id, project_id: project_one.id)).not_to be_nil
      project_one.reload
      expect(project_one.allowed_users).to include(user_two)
    end
    
    it "can access destroy on a project you own" do
      expect(project_three.allowed_users).to include(user_two)
      expect { delete(project_team_membership_url(project_three, membership_p_three)) }.to change { TeamMembership.count }.by(-1)
      expect { membership_p_three.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
  
  
  context "For a logged out user" do 
    
    it "can't access new" do 
      get new_project_team_membership_url(project_one)
      expect(request).to redirect_to(new_user_session_path)
    end

    it "can't access create" do 
      expect(project_one.allowed_users).not_to include(user_two)
      post(project_team_memberships_url(project_one), params: { project_id: project_one.id,
                                                   user_id: user_two.id })
      expect(request).to redirect_to(new_user_session_path)
      expect(TeamMembership.find_by(user_id: user_two.id, project_id: project_one.id)).to be_nil
      expect(project_one.allowed_users).not_to include(user_two)
    end
    
    it "can't access destroy" do 
      expect(project_three.allowed_users).to include(user_two)
      expect { delete(project_team_membership_url(project_three, membership_p_three)) }.to change { TeamMembership.count }.by(0)
      expect(request).to redirect_to(new_user_session_path)
    end
  end
  
  context "Authorization" do 
    
    before(:each) do 
      sign_in(user)
    end
    
    it "can't access new on a project you don't own" do 
      get new_project_team_membership_url(project_no_t)
      expect(request).to redirect_to(root_url)
    end
    
    it "can't access create on a project you don't own" do 
      expect(project_no_t.allowed_users).not_to include(user_three)
      post(project_team_memberships_url(project_no_t), params: { project_id: project_two.id,
                                                   user_id: user_three.id })
      expect(request).to redirect_to(root_url)
      expect(TeamMembership.find_by(user_id: user_three.id, project_id: project_no_t.id)).to be_nil
      expect(project_no_t.allowed_users).not_to include(user_three)
    end
    
    it "can't access destroy on a project you don't own" do
      expect(project_two.allowed_users).to include(user_three)
      expect { delete(project_team_membership_url(project_two, membership_p_two)) }.to change { TeamMembership.count }.by(0)
      expect(TeamMembership.find_by(project_id: project_two.id, user_id: user_three.id)).not_to be_nil
      expect(project_two.allowed_users).to include(user_three)
    end
   
  end
end