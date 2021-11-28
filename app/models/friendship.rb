class Friendship < ApplicationRecord
  enum status: %i[pending accepted declined]

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  scope :friendship_accepted, -> { includes(%i[sender receiver]).where(status: :accepted) }
  scope :friendship_pending, -> { includes(%i[sender receiver]).where(status: :pending) }
  scope :friendship_declined, -> { includes(%i[sender receiver]).where(status: :declined) }
end
