module SessionsHelper

  def current_user?(user)
    user == current_user
  end

  def current_user
    begin
      if cookies[:auth_token]
        @current_user ||= User.find_by_auth_token!(cookies[:auth_token])
      end
    rescue ActiveRecord::RecordNotFound
      @current_user = nil
    end
  end

  def current_user=(user)
    @current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_in(user)
    cookies[:auth_token] = user.auth_token
  end

  def signed_in
    redirect_to signin_path unless signed_in?
  end

  def owner
    unless current_user?(User.find(params[:id]))
      flash[:error] = "You're not allowed to do that. Please sign in."
      redirect_to signin_path
    end
  end

  def owner?
      current_user?(User.find(params[:user_id]))
  end

  def owner_of
    unless (Item.find(params[:id])).user_id == current_user.id
      flash[:error] = "You're not allowed to do that."
      redirect_to current_user 
    end
  end
end
