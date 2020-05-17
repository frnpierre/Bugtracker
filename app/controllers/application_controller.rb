class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: [:become_user]
  
  def become_user
    user = User.find(params[:id])
    sign_in(:user, user)
    flash[:success] = "You logged in as #{user.username}"
    redirect_to request.referrer
  end
end
