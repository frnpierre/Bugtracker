class ProjectsController < ApplicationController
  
  def new
    @project = Project.new
  end
  
  def create
    @project = Project.new(project_params)
    if @project.save
      flash[:success] = "You created the project: #{@project.name}"
      redirect_to root_url
    else 
      flash.now[:error] = "There was something wrong."
      render :new
    end
  end
  
  private
  
    def project_params
      params.require(:project).permit(:name).merge(user: current_user)
    end
end
