class ProjectsController < ApplicationController
  before_action :allow_only_owner, only: [:show, :edit, :update, :destroy]
  

  def index
    @projects = Project.where(user: current_user)
  end
  
  def show
    @project = Project.find(params[:id])
    @project_bugs = @project.bugs.order(:id).includes(:comments)
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
      flash.now[:danger] = "There was something wrong."
      render :new
    end
  end
  
  def update 
    @project = Project.find(params[:id])
    if @project.update_attributes(project_params)
      flash[:success] = "Project updated."
      redirect_to projects_path
    else 
      flash.now[:danger] = "There was an error."
      render :edit
    end
  end
  
  def destroy 
    @project = Project.find(params[:id])
    if @project.destroy
      flash[:success] = "Project #{@project.name} deleted"
      redirect_to projects_url 
    else 
      flash[:danger] = "There was an error."
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
end
