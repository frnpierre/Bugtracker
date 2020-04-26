class Project < ApplicationRecord
  belongs_to :user
  has_many :bugs, dependent: :destroy
  
  has_many :team_memberships
  has_many :allowed_users, through: :team_memberships, source: :user
end
