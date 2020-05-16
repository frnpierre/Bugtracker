class Bug < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  
  belongs_to :project
  belongs_to :user
  
  has_many :comments, -> { includes(:user) }, dependent: :destroy
  
  def mark_as_solved
    self.update_attributes(solved: true)
  end
  
  def mark_as_unsolved
    self.update_attributes(solved: false)
  end
end