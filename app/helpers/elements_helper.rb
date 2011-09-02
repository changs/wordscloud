module ElementsHelper
  def how_many_to_review
    current_user.elements.where(
      "to_review <= ?", Time.now.end_of_day ).count
  end
  def how_many_elements
    current_user.elements.count
  end
end
