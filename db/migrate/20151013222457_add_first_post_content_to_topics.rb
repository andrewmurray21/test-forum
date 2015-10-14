class AddFirstPostContentToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :first_post_content, :string
  end
end
