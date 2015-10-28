require 'test_helper'

class ForumTest < ActiveSupport::TestCase
  def setup
    @forum = Forum.new(title: "Forum1")
    @user = users(:one)
    #@topic = topics(:one)
  end

  test "should be valid" do
    assert @forum.valid?
  end

  test "title should be at most 100 characters" do
    @forum.title = "a" * 101
    assert_not @forum.valid?
  end

  test "title should be at least 3 characters" do
    @forum.title = "a" * 2
    assert_not @forum.valid?
  end

  test "associated topics should be destroyed" do
    @forum.save
    @topic = @forum.topics.create!(title: "Test Title", forum_id: @forum.id, 
      first_post_content: "first_post_content")
    @topic.posts.create!(content: "Test Content", topic_id: @topic.id,
                         user_id: @user.id)
    assert_difference 'Topic.count', -1 do
      @forum.destroy
    end
  end

  test "associated posts (through topics) should be destroyed" do
    @forum.save
    @topic = @forum.topics.create!(title: "Test Title", forum_id: @forum.id, 
      first_post_content: "first_post_content")
    @topic.posts.create!(content: "Test Content", topic_id: @topic.id,
                         user_id: @user.id)
    assert_difference 'Post.count', -1 do
      @forum.destroy
    end
  end
end
