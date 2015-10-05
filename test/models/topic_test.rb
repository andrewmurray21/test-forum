require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @forum = forums(:one)
    @user = users(:one)
    @topic = Topic.new(title: "Topic1", forum_id: @forum.id)
  end

  test "should be valid" do
    assert @topic.valid?
  end

  test "forum id should be present" do
    @topic.forum_id = nil
    assert_not @topic.valid?
  end

  test "associated posts should be destroyed" do
    @topic.save
    @topic.posts.create!(content: "Test Content", topic_id: @topic.id,
                         user_id: @user.id)
    assert_difference 'Post.count', -1 do
      @topic.destroy
    end
  end
end
