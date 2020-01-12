class ProjectsController < ApplicationController
  
  def index
    @projects = Project.where(user: current_user)
  end
  
  def show
    @project = Project.find(params[:id])
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
      flash.now[:error] = "There was something wrong."
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
  
  private
  
    def project_params
      params.require(:project).permit(:name).merge(user: current_user)
    end
end
