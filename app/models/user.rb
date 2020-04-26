class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
         :recoverable, :rememberable, :validatable
  
  has_many :projects
  has_many :bugs
  has_many :comments
  
  has_many :team_memberships
  has_many :allowed_projects, through: :team_memberships, source: :project
end
