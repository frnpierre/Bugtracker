class Bug < ApplicationRecord
  belongs_to :project
  belongs_to :user
  
  has_many :comments, -> { includes(:user) }
  
  def mark_as_solved
    self.update_attributes(solved: true)
  end
  
  def mark_as_unsolved
    self.update_attributes(solved: false)
  end
end