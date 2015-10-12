class Topic < ActiveRecord::Base
  belongs_to :forum
  has_many :posts, dependent: :destroy
  has_many :users, through: :posts
  belongs_to :last_post, class_name: "Post", foreign_key: "last_post_id"

  attr_accessor :last_post_id

  validates :title, presence: true, length: { maximum: 100 }
  validates :forum_id, presence: true
end
