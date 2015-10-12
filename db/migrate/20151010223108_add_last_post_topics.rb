class AddLastPostTopics < ActiveRecord::Migration
  def change
    add_reference :topics, :last_post, references: :posts, index: true
    add_foreign_key :topics, :posts, column: :last_post_id
  end
end
