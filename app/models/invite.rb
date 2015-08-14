class Invite < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :friend_email

end