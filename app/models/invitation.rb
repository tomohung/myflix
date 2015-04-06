class Invitation < ActiveRecord::Base

  validates_presence_of :inviter_id, :recipient_name, :recipient_email, :message

end