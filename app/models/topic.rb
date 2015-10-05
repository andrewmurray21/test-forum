class Topic < ActiveRecord::Base
  belongs_to :forum
  has_many :posts, dependent: :destroy
  has_many :users, through: :posts

  validates :title, presence: true, length: { maximum: 100 }
  validates :forum_id, presence: true
end
