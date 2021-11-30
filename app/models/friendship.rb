class Friendship < ApplicationRecord
  enum status: %i[pending accepted declined]

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  scope :friendship_accepted, -> { where(status: :accepted) }
  scope :friendship_pending, -> { where(status: :pending) }
  scope :friendship_declined, -> { where(status: :declined) }
end
