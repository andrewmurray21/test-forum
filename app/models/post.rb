class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  has_one :forum, through: :topic

  default_scope -> { order(created_at: :desc) }

  validates :content, presence: true, length: { minimum: 3, maximum: 1000 }
  validates :user_id, presence: true
  validates :topic_id, presence: true
end
