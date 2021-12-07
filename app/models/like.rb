class Like < ApplicationRecord
  belongs_to :post
  belongs_to :comment, optional: true
  belongs_to :user
end
