class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :profile_picture, dependent: :destroy

  validates :profile_picture, attached: true,
                              content_type: %w[image/png image/jpg image/jpeg],
                              size: { less_than: 10.megabytes, message: 'image must be less than 10MB' },
                              unless: proc { |profile| profile.profile_picture.blank? }
end
