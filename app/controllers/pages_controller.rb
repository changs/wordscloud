class PagesController < ApplicationController
  def index
    if signed_in?
      redirect_to current_user
    else
      render 'welcome'
    end 
  end

  def new_user
    @user = User.new
  end
end
