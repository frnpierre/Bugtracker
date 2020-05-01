require 'rails_helper'

RSpec.describe Bug, type: :model do
  
  let(:user) { create(:user) }
  let(:project) { create(:project, name: "Model bug project name",
                                  user: user) }
  let!(:bug) { create(:bug, description: "Model bug test",
                                  project: project,
                                  user: user) }
  
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
end
