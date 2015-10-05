class Forum < ActiveRecord::Base
  has_many :topics
  has_many :posts, through: :topics

  validates :title, presence: true, length: { maximum: 100 }
end
