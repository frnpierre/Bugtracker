require 'rails_helper'

RSpec.describe Project, type: :model do
  
  let(:user) { create(:user) }
  let(:project) { user.projects.build }
  
  context "Validations:" do 
    
    it "name should be present" do 
      expect(project.valid?).to be_falsy
      expect(project.errors.messages[:name]).not_to be_empty
    end
    
    it "description should be present" do 
      expect(project.valid?).to be_falsy
      expect(project.errors.messages[:description]).not_to be_empty
    end
  end
end
