class Like < ApplicationRecord
  default_scope { includes([:user]).references(:user) }
  
  belongs_to :user
  belongs_to :likeable, polymorphic: true
end
