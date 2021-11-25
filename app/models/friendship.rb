class Friendship < ApplicationRecord
  enum status: %i[pending accepted declined]

  belongs_to :user
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'
end
