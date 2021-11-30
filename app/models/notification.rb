class Notification < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  scope :unread, -> { where(read: false) }
end
