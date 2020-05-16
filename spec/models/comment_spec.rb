require 'rails_helper'

RSpec.describe Comment, type: :model do
  
  let(:user) { create(:user) }
  let(:project) { create(:project, name: "Model bug project name",
                                  user: user) }
  let!(:bug) { create(:bug, description: "Model bug test",
                                  project: project,
                                  user: user) }
  let(:comment_to_validate) { bug.comments.build }
  
  context "Validations:" do 
    
    it "content should be present" do 
      expect(comment_to_validate.valid?).to be_falsy
      expect(comment_to_validate.errors.messages[:content]).not_to be_empty
    end
  end
end
