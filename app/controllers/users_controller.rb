class UsersController < ApplicationController
  before_filter :owner, only: [:edit, :update]
  before_filter :signed_in
  skip_before_filter :signed_in, only: [:new, :create]
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
    if params[:id] && current_user != @user 
      @feed_items = @user.items.where("public = ?", true).paginate(page: params[:page])
      render "show_current"
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
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
  
  def index
    @user = current_user
    @application_layout = true
    @users = User.search(params[:search])
  end

  def following
    @application_layout = true
    @user = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @application_layout = true
    @user = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
  def user_layout
    @application_layout == true ? "application" : "pages"
  end
end
