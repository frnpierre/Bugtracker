class CommentsController < ApplicationController
  before_action :allow_only_team
  
  def create
    @project = Project.find(params[:comment][:project_id])
    @comment = Comment.new(comment_params)
    
    respond_to do |format|
      if @comment.save 
        format.html do 
          flash[:success] = "Comment saved."
          redirect_to @project
        end
        format.js
        format.json { render json: @comment, status: :created, location: @comment }
        
      else 
        format.html do 
          flash[:error] = "There was an error while creating your comment."
          redirect_to @project
        end
        format.json { render json: @json.errors, status: unprocessable_entity }
      end
    end
  end
  
  private
  
    def comment_params
      params.require(:comment).permit(:content, :bug_id).merge(user_id: current_user.id)
    end
    
    def allow_only_team
      @project = Project.find(params[:comment][:project_id])
      allowed_team_ids = @project.allowed_user_ids << @project.user_id
      if !allowed_team_ids.include?(current_user.id)
        flash[:error] = "You're not allowed to comment on this bug."
        redirect_to root_url 
      end
    end
end