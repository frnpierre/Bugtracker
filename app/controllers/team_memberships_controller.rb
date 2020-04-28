class TeamMembershipsController < ApplicationController
  
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
      flash.now[:error] = "There was an error."
      render :new
    end
  end
  
end
