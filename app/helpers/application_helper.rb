module ApplicationHelper

  def options_for_video_reviews(selected = nil)
    options_for_select([5, 4, 3, 2, 1].map {|number| [pluralize(number, 'Star'), number]}, selected)
  end

  def payment_amount_in_dollars(amount)
    number_to_currency(amount * 0.01)
  end

end
