class UsersController < ApplicationController
  before_filter :owner, only: [:edit, :update]
  def new
   @user = User.new 
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = "Your account has been created. Welcome to Wordscloud!"
      sign_in @user
      redirect_to @user
    else
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
