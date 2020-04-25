class CommentsController < ApplicationController
  
  def create
    @project = Project.find(params[:comment][:project_id])
    @comment = Comment.new(comment_params)
    if @comment.save 
      flash[:success] = "Comment saved."
      redirect_to @project
    else 
      flash[:error] = "There was an error with your comment."
      redirect_to @project
    end
  end
  
  private
  
    def comment_params
      params.require(:comment).permit(:content, :bug_id).merge(user_id: current_user.id)
    end
end