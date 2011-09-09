module ItemsHelper
  def how_many_to_review
    current_user.items.where(
      "review_at <= ?", Time.now.end_of_day ).count
  end
  def how_many_items
    current_user.items.count
  end
end
