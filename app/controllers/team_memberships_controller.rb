class TeamMembershipsController < ApplicationController
  
  before_action :allow_only_owner, only: [:new, :create, :destroy]
  
  def new
    @project = Project.find(params[:project_id])
    @users = User.select { |user| user.id != current_user.id && !@project.allowed_user_ids.include?(user.id) }
  end
  
  def create
    @project = Project.find(params[:project_id])
    @user = User.find(params[:user_id])
    @membership = @project.team_memberships.build(user: @user)
    if @membership.save
      flash[:success] = "#{@user.username} was added to this project team."
      redirect_to project_url(@project)
    else 
      flash.now[:error] = "There was an error while adding this user to the project team."
      render :new
    end
  end
  
  def destroy
    @team_membership = TeamMembership.find(params[:id])
    if @team_membership.delete
      flash[:success] = "#{@team_membership.user.username} was removed from this project team."
      redirect_to project_path(@team_membership.project)
    else 
      flash[:error] = "There was an error while removing this user from the project team."
      redirect_to project_path(@team_membership.project)
    end
  end
  
  private 
  
    def allow_only_owner
      @project = Project.find(params[:project_id]) || TeamMembership.find(params[:id]).project
      redirect_to root_url if current_user.id != @project.user_id
    end
end
