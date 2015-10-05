class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic
  has_one :forum, through: :topic

  validates :content, presence: true, length: { maximum: 1000 }
end
