class Like < ApplicationRecord
  belongs_to :user, foreign_key: 'user_id'
  belongs_to :likeable, polymorphic: true
end
