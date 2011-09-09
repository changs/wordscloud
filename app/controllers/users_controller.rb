class UsersController < ApplicationController
  before_filter :owner, only: [:edit, :update]
  layout :user_layout

  def new
    @application_layout = false
    if request.post?
      @title = "You are almost done!"
      @user = User.new(username: params[:fullname].gsub(/\s+/,'').downcase,
                       fullname: params[:fullname],
                       email: params[:email],
                       password: params[:password])
      @user.valid?
      @passw = params[:password]
    else
      @title = "Create a new user"
      @user = User.new
      @passw = ""
    end
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Your account has been created. Welcome to Wordscloud!"
      sign_in @user
      redirect_to @user
    else
      @title = "You are almost done!"
      @passw = params[:user][:password]
      @application_layout = false
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
    @application_layout = true
  end

  def edit
    @user = User.find(params[:id])
    @application_layout = true
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      @application_layout = true
      render "edit"
    end
  end

  private
  def user_layout
    @application_layout == true ? "application" : "pages"
  end
end
