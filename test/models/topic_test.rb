require 'test_helper'

class TopicTest < ActiveSupport::TestCase
  def setup
    @forum = forums(:one)
    @user = users(:one)
    @topic = Topic.new(title: "Topic1", forum_id: @forum.id,
      first_post_content: "first post")
  end

  test "should be valid" do
    assert @topic.valid?
  end

  test "forum id should be present" do
    @topic.forum_id = nil
    assert_not @topic.valid?
  end

  test "title should be present nil" do
    @topic.title = nil
    assert_not @topic.valid?
  end

  test "title should be present blank" do
    @topic.title = "      "
    assert_not @topic.valid?
  end

  test "title should be at most 100 characters" do
    @topic.title = "a" * 101
    assert_not @topic.valid?
  end

  test "title should be at least 3 characters" do
    @topic.title = "a" * 2
    assert_not @topic.valid?
  end

  test "first post should be present nil" do
    @topic.first_post_content = nil
    assert_not @topic.valid?
  end

  test "first post should be present blank" do
    @topic.first_post_content = "      "
    assert_not @topic.valid?
  end

  test "first post should be at most 100 characters" do
    @topic.first_post_content = "a" * 1001
    assert_not @topic.valid?
  end

  test "first post should be at least 3 characters" do
    @topic.first_post_content = "a" * 2
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
