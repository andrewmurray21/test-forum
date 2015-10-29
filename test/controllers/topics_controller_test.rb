require 'test_helper'

class TopicsControllerTest < ActionController::TestCase

  def setup
    @post = posts(:one)
    @post3 = posts(:three)
    @forum = forums(:one)
    @forum2 = forums(:two)
    @forum3 = forums(:three)
    @topic = topics(:one)
    @user = users(:one)
    @user2 = users(:two)
    @user4 = users(:four)
  end

  test "should get show" do
    log_in_as(@user)
    get(:show, id: @forum2.id)
    assert_response :success
  end

  test "should redirect show when not logged in" do
    get(:show, {'id' => @forum3.id})
    assert_redirected_to login_url
  end

  test "should get create" do
    log_in_as(@user)
    assert_difference 'Topic.count', +1 do
      post :create, topic: { title: "title", forum_id: @forum.id,
        first_post_content: "first post" }
    end
    assert_redirected_to topics_show_path(id: @forum.id)
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      post :create, topic: { title: "title", forum_id: @forum.id,
        first_post_content: "first post" }
    end
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @topic, topic: { title: "Post1" }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as non post owner user" do
    log_in_as(@user4)
    patch :update, id: @topic, topic: { title: "Post1" }
    assert_redirected_to root_url
  end

  test "should allow update when logged in as admin user" do
    log_in_as(@user)
    patch :update, id: @topic, topic: { title: "Post1" }
    assert_not flash.empty?
    assert_redirected_to topics_show_path(id: @topic.forum.id)
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Topic.count' do
      delete :destroy, id: @topic
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as non first post owner user" do
    log_in_as(@user2)
    assert_no_difference 'Topic.count' do
      delete :destroy, id: @post3.topic
    end
    assert_redirected_to root_url
  end

  test "should allow destroy when logged in as first post owner" do
    log_in_as(@user4)
    assert_difference 'Topic.count', -1 do
      delete :destroy, id: @post3.topic
    end
    assert_redirected_to topics_show_path(id: @post3.topic.forum.id)
  end

  test "should allow destroy when logged in as admin user" do
    log_in_as(@user)
    assert_difference 'Topic.count', -1 do
      delete :destroy, id: @post.topic
    end
    assert_redirected_to topics_show_path(id: @post.topic.forum.id)
  end


end
