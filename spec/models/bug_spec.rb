require 'rails_helper'

RSpec.describe Bug, type: :model do
  
  let(:user) { create(:user) }
  let(:project) { create(:project, name: "Model bug project name",
                                  user: user) }
  let!(:bug) { create(:bug, description: "Model bug test",
                                  project: project,
                                  user: user) }
  let(:bug_to_validate) { project.bugs.build }
  
  it "A new record should have a solved status of false" do 
    expect(bug.solved).to be_falsy
  end
  
  it "Can be marked as solved" do
    expect(bug.solved).to be_falsy
    bug.mark_as_solved
    bug.reload
    expect(bug.solved).to be_truthy
  end
  
  it "Can be marked as unsolved" do
    bug.update_attributes(solved: true)
    bug.reload
    bug.mark_as_unsolved
    bug.reload
    expect(bug.solved).to be_falsy
  end
  
  context "Validations:" do 
    
    it "name should be present" do 
      expect(bug_to_validate.valid?).to be_falsy
      expect(bug_to_validate.errors.messages[:name]).not_to be_empty
      bug_to_validate.name = "Valid name"
      bug_to_validate.valid?
      expect(bug_to_validate.errors.messages[:name]).to be_empty
    end
    
    it "description should be present" do 
      expect(bug_to_validate.valid?).to be_falsy
      expect(bug_to_validate.errors.messages[:description]).not_to be_empty
      bug_to_validate.description = "Valid description"
      bug_to_validate.valid?
      expect(bug_to_validate.errors.messages[:description]).to be_empty
    end
  end
end
