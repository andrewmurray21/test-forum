require 'test_helper'

class PostTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @topic = topics(:one)
    @post = Post.new(content: "Post1", user_id: @user.id, topic_id: @topic.id)
  end

  test "should be valid" do
    assert @post.valid?
  end

  test "user id should be present" do
    @post.user_id = nil
    assert_not @post.valid?
  end

  test "topic id should be present" do
    @post.topic_id = nil
    assert_not @post.valid?
  end

  test "content should be present" do
    @post.content = "   "
    assert_not @post.valid?
  end

  test "content should be at most 140 characters" do
    @post.content = "a" * 1001
    assert_not @post.valid?
  end

  test "order should be most recent first" do
    assert_equal posts(:most_recent), Post.first
  end

end
