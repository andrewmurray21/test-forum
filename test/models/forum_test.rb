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

  test "associated topics should be destroyed" do
    @forum.save
    @topic = @forum.topics.create!(title: "Test Title", forum_id: @forum.id)
    @topic.posts.create!(content: "Test Content", topic_id: @topic.id,
                         user_id: @user.id)
    assert_difference 'Topic.count', -1 do
      @forum.destroy
    end
  end

  test "associated posts (through topics) should be destroyed" do
    @forum.save
    @topic = @forum.topics.create!(title: "Test Title", forum_id: @forum.id)
    @topic.posts.create!(content: "Test Content", topic_id: @topic.id,
                         user_id: @user.id)
    assert_difference 'Post.count', -1 do
      @forum.destroy
    end
  end
end
