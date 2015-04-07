require 'tokenable'

class Invitation < ActiveRecord::Base

  include Tokenable
  validates_presence_of :inviter_id, :recipient_name, :recipient_email, :message
  belongs_to :inviter, class_name: 'User'

end