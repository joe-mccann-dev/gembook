class Profile < ApplicationRecord
  default_scope { includes(profile_picture_attachment: :blob) }
  belongs_to :user
  has_one_attached :profile_picture, dependent: :destroy

  validates :profile_picture, attached: true,
                              content_type: %w[image/png image/jpg image/jpeg],
                              size: { less_than: 10.megabytes, message: 'image must be less than 10MB' },
                              unless: proc { |profile| profile.profile_picture.blank? }

  
  validates :bio, length: { maximum: 500 }
  validates :nickname, length: { maximum: 50 }
  validates :current_city, length: { maximum: 25 }
  validates :hometown, length: { maximum: 25 }
  
  def self.attach_and_save_auth_image(auth, user)
    return if exists?(user_id: user.id )

    image_file = Down.download(auth.info.image)
    filename = File.basename(image_file.path)
    profile = user.build_profile
    profile.profile_picture.attach(io: image_file, filename: filename)
    profile.save
  end
end
