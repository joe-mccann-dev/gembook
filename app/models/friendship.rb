class Friendship < ApplicationRecord
  enum status: %i[pending accepted declined]

  belongs_to :friendable, polymorphic: true
end
