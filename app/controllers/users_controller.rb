class UsersController < ApplicationController
  before_filter :owner, only: [:edit, :update]
  def new
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
      render "new"
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render "edit"
    end
  end
end
