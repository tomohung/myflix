class Payment < ActiveRecord::Base
  belongs_to :user

  def amount_in_dollars
    "$#{amount * 0.01}"
  end
end
