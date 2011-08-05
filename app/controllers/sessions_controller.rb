class SessionsController < ApplicationController

  def new
    
  end

  def create
    user = User.find_by_username(params[:username])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      flash[:success] = "You are signed in"
      redirect_to user
    else
      flash[:error] = "Wrong username or password"
      render 'new'
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to root_path, notice: "You have been signed out"
  end

end
