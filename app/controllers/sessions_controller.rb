class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "You are logged into the chess camp system"
    else
      flash.now.alert = "Username or password is invalid"
      render "new"
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out!"
  end
  
end