require 'rails_helper'

RSpec.describe Project, type: :model do
  
  let(:user) { create(:user) }
  let(:project_to_validate) { user.projects.build }
  
  context "Validations:" do 
    
    it "name should be present" do 
      expect(project_to_validate.valid?).to be_falsy
      expect(project_to_validate.errors.messages[:name]).not_to be_empty
      project_to_validate.name = "Valid name"
      project_to_validate.valid?
      expect(project_to_validate.errors.messages[:name]).to be_empty
    end
    
    it "description should be present" do 
      expect(project_to_validate.valid?).to be_falsy
      expect(project_to_validate.errors.messages[:description]).not_to be_empty
      project_to_validate.description = "Valid description"
      project_to_validate.valid?
      expect(project_to_validate.errors.messages[:description]).to be_empty
    end
  end
end
