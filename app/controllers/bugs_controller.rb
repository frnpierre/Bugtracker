class BugsController < ApplicationController
  
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
  
  private
  
    def bug_params
      params.require(:bug).permit(:description).merge(user: current_user)
    end
end
