class ItemsController < ApplicationController
  before_filter :signed_in
  before_filter :owner_of, only: [:edit, :update, :reviewed]
  def show
    #redirect_to current_user
  end

  def index
    if params[:user_id].nil?
      @items = current_user.items.paginate(per_page: 1, page: params[:page])
      @owner = true
    else
      @owner = false
      @owner_name = User.find_by_id(params[:user_id]).username
      @items = User.find_by_id(params[:user_id]).items.where("public" => true).paginate(per_page: 1, page: params[:page])
    end
  end

  def new
    @item = Item.new(user: current_user)
  end

  def create
    @item = current_user.items.new(params[:item])
    if @item.save
      flash[:success] = "Done"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def update
    if current_user.items.find(params[:id]).update_attributes(params[:item])
      flash[:success] = "Item updated"
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def review
    unless Item.next_review_at(current_user)
      flash[:notice] = "Great! You have reviewed all items for today."
      redirect_to current_user
    end
    @item = Item.next_review_at(current_user)
  end

  def reviewed
    grades = { "Ideal" => 5, "Good" => 4, "Pass" => 3, "Bad" => 2, "Null" => 1 }
    el = Item.find_by_id(params[:id])
    el.update_ef(grades[params[:commit]])
    el.save
    @item = Item.next_review_at(current_user)
    respond_to do |format|
      format.js 
      format.html { render 'reviev' }
    end
  end
end
