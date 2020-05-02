class BugsController < ApplicationController
  before_action :allow_only_team, only: [:new, :create]
  before_action :allow_only_owners, only: [:edit, :update, :destroy, :update_solved_status]
  
  def new
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build
  end
  
  def edit
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
  end
  
  def create
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build(bug_params)
    if @bug.save
      flash[:success] = "Bug reported."
      redirect_to project_path(@bug.project)
    else 
      flash.now[:error] = "There was something wrong."
      render :new
    end
  end
  
  def update
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    if @bug.update_attributes(bug_params)
      flash[:success] = "Bug updated."
      redirect_to project_path(@project)
    else 
      flash.now[:danger] = "There was an error."
      render :edit
    end
  end
  
  def destroy
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.find(params[:id])
    if @bug.destroy
      flash[:success] = "Bug deleted."
      redirect_to project_path(@project)
    else 
      flash[:danger] = "There was an error."
      redirect_to project_path(@project)
    end
  end
  
  def update_solved_status
    @bug = Bug.find(params[:id])
    if @bug.solved?
      @bug.mark_as_unsolved
      flash[:success] = "Bug marked as unsolved."
      redirect_to project_path(@bug.project)
    else 
      @bug.mark_as_solved
      flash[:success] = "Bug marked as solved."
      redirect_to project_path(@bug.project)
    end
  end
  
  private
  
    def bug_params
      params.require(:bug).permit(:name, :description).merge(user: current_user)
    end
    
    def allow_only_team
      @project = Project.find(params[:project_id])
      allowed_team_ids = @project.allowed_user_ids << @project.user_id
      if !allowed_team_ids.include?(current_user.id)
        flash[:error] = "You're not allowed to access this project."
        redirect_to root_url 
      end
    end
    
    def allow_only_owners
      if params[:project_id]
        @project = Project.find(params[:project_id])
        @bug = @project.bugs.find(params[:id])
      else 
        @bug = Bug.find(params[:id])
        @project = @bug.project
      end
      
      if current_user.id != @project.user_id && current_user.id != @bug.user_id
        flash[:error] = "You're not allowed to access this bug."
        redirect_to root_url
      end
    end
end
