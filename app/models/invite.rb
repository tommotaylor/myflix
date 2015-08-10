class Invite < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :friend_email

  def send_invitation
    self.invite_sent_at = Time.now
    save!
    AppMailer.send_invite(self).deliver
  end
end