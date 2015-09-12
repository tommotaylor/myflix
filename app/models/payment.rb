class Payment < ActiveRecord::Base

  belongs_to :user

  def display_amount
    price = amount.to_d/100
    "£#{price}"
  end
end