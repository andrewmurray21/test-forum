require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  def setup
    @post = posts(:one)
    @post3 = posts(:three)
    @post4 = posts(:four)
    @forum = forums(:one)
    @topic = topics(:one)
    @user = users(:one)
    @user2 = users(:two)
    @user4 = users(:four)
  end

  test "should get show" do
    log_in_as(@user)
    get(:show, {'forum_id' => @post.topic.forum.id, 
      'topic_id' => @post.topic.id})
    assert_response :success
  end

  test "should redirect show when not logged in" do
    get(:show, {'forum_id' => @post.topic.forum.id, 
      'topic_id' => @post.topic.id})
    assert_redirected_to login_url
  end

  test "should get create" do
    log_in_as(@user)
    assert_difference 'Post.count', +1 do
      post :create, post: { content: "Post1", forum_id: @forum.id,
        topic_id: @topic.id }
    end
    assert_redirected_to posts_show_path(forum_id: @forum.id,
      topic_id: @topic.id)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      post :create, post: { content: "Post1" }
    end
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @post, post: { content: "Post1" }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as non post owner user" do
    log_in_as(@user4)
    patch :update, id: @post, post: { content: "Post1" }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should allow update when logged in as admin user" do
    log_in_as(@user)
    patch :update, id: @post, post: { content: "Post1" }
    assert_not flash.empty?
    assert_redirected_to posts_show_path(forum_id: @post.topic.forum.id,
      topic_id: @post.topic.id)
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Post.count' do
      delete :destroy, id: @post
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non post owner user" do
    log_in_as(@user2)
    assert_no_difference 'Post.count' do
      delete :destroy, id: @post3
    end
    assert_redirected_to root_url
  end

  test "should allow destroy when logged in as post owner" do
    log_in_as(@user4)
    assert_difference 'Post.count', -1 do
      delete :destroy, id: @post4
    end
    assert_redirected_to posts_show_path(forum_id: @post4.topic.forum.id,
      topic_id: @post4.topic.id)
  end

  test "should allow destroy when logged in as admin user" do
    log_in_as(@user)
    assert_difference 'Post.count', -1 do
      delete :destroy, id: @post
    end
    assert_redirected_to posts_show_path(forum_id: @post.topic.forum.id,
      topic_id: @post.topic.id)
  end

end
