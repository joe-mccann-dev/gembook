class Post < ApplicationRecord
  paginates_per 25
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :likers, through: :likes, source: :user
  has_one_attached :image, dependent: :destroy

  validates :image, attached: true,
                    content_type: %w[image/png image/jpg image/jpeg],
                    size: { less_than: 10.megabytes, message: 'image must be less than 10MB' },
                    unless: proc { |post| post.image.blank? }

  validates :content, presence: true,
                      unless: proc { |post| post.image.attached? }
  validates :content, length: { in: 2..10**4 },
                      unless: proc { |post| post.image.attached? }                        

  def edited?
    second_created = created_at.to_datetime.second
    second_updated = updated_at.to_datetime.second
    second_created != second_updated
  end
end
