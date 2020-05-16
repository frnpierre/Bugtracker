class ProjectsController < ApplicationController
  before_action :allow_only_owner, only: [:edit, :update, :destroy]
  before_action :allow_only_team, only: [:show]
  

  def index
    @projects = Project.where(user: current_user) + current_user.allowed_projects
  end
  
  def show
    @project = Project.find(params[:id])
    @project_solved_bugs = @project.bugs.where(solved: true).order(:id).includes(:user, :comments)
    @project_unsolved_bugs = @project.bugs.where(solved: false).order(:id).includes(:user, :comments)
    @comment = Comment.new
  end
  
  def new
    @project = Project.new
  end
  
  def edit 
    @project = Project.find(params[:id])
  end
  
  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = "You created the project: #{@project.name}"
      redirect_to projects_path
    else 
      flash.now[:error] = "There was an error while creating the project."
      render :new
    end
  end
  
  def update 
    @project = Project.find(params[:id])
    if @project.update_attributes(project_params)
      flash[:success] = "Project updated."
      redirect_to projects_path
    else 
      flash.now[:error] = "There was an error while updating the project."
      render :edit
    end
  end
  
  def destroy 
    @project = Project.find(params[:id])
    if @project.destroy
      flash[:success] = "Project #{@project.name} deleted"
      redirect_to projects_url 
    else 
      flash[:error] = "There was an error while deleting the project."
      redirect_to projects_url
    end
  end
  
  private
  
    def project_params
      params.require(:project).permit(:name, :description).merge(user: current_user)
    end
    
    def allow_only_owner
      @project = Project.find(params[:id])
      redirect_to root_url if current_user.id != @project.user_id
    end
    
    def allow_only_team
      @project = Project.find(params[:id])
      allowed_team_ids = @project.allowed_user_ids << @project.user_id
      if !allowed_team_ids.include?(current_user.id)
        flash[:error] = "You're not allowed to access this project."
        redirect_to root_url 
      end
    end
end
