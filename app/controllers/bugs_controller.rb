class BugsController < ApplicationController
  
  def new
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build
  end
  
  def create
    @project = Project.find(params[:project_id])
    @bug = @project.bugs.build(bug_params)
    if @bug.save
      flash[:success] = "Bug reported"
      redirect_to project_path(@bug.project)
    else 
      flash.now[:error] = "There was something wrong."
      render :new
    end
  end
  
  private
  
    def bug_params
      params.require(:bug).permit(:description)
    end
end
