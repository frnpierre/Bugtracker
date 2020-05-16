class Project < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  
  belongs_to :user
  has_many :bugs, dependent: :destroy
  
  has_many :team_memberships, dependent: :destroy
  has_many :allowed_users, through: :team_memberships, source: :user
end
