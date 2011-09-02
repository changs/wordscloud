class ElementsController < ApplicationController
  before_filter :signed_in
  before_filter :owner_of, only: [:edit, :update, :reviewed]
  def show
    #redirect_to current_user
  end

  def index
    @elements = current_user.elements.all
  end

  def new
    @element = Element.new(user: current_user)
  end

  def create
    @element = current_user.elements.new(params[:element])
    if @element.save
      flash[:success] = "Done"
      redirect_to current_user
    else
      render 'new'
    end
  end

  def edit
    @element = current_user.elements.find(params[:id])
  end

  def update
    if current_user.elements.find(params[:id]).update_attributes(params[:element])
      flash[:success] = "Item updated"
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def review
    unless Element.next_to_review(current_user)
      flash[:notice] = "Great! You have reviewed all items for today."
      redirect_to current_user
    end
    @element = Element.next_to_review(current_user)
  end

  def reviewed
    grades = { "Ideal" => 5, "Good" => 4, "Pass" => 3, "Bad" => 2, "Null" => 1 }
    el = Element.find_by_id(params[:id])
    el.update_ef(grades[params[:commit]])
    el.save
    @element = Element.next_to_review(current_user)
    respond_to do |format|
      format.js 
      format.html { render 'reviev' }
    end
  end
end
