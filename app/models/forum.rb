class Forum < ActiveRecord::Base
  has_many :topics, dependent: :destroy
  has_many :posts, through: :topics, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
end
