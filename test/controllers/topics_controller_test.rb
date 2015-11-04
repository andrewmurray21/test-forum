require 'test_helper'

class TopicsControllerTest < ActionController::TestCase

  def setup
    @post2 = posts(:Post2)
    @forum = forums(:Forum1)
    @topic = topics(:Topic1)
    @user = users(:one)
    @user2 = users(:two)
    @user4 = users(:four)
  end

  test "should get show" do
    log_in_as(@user)
    get(:show, id: @forum.id)
    assert_response :success
  end

  test "should redirect show when not logged in" do
    get(:show, {'id' => @forum.id})
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

  test "should not allow create with invalid data" do
    log_in_as(@user)
    assert_no_difference 'Topic.count' do
      post :create, topic: { title: "t", forum_id: @forum.id,
        first_post_content: "first post" }
    end
    assert_response :success # form-control reload page
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Post.count' do
      post :create, topic: { title: "title", forum_id: @forum.id,
        first_post_content: "first post" }
    end
    assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @topic, topic: { title: "Topic1" }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as non post owner user" do
    log_in_as(@user4)
    patch :update, id: @topic, topic: { title: "Topic1" }
    assert_redirected_to root_url
  end

  test "should allow update when logged in as admin user" do
    log_in_as(@user)
    patch :update, id: @topic, topic: { title: "Topic1" }
    assert_equal "Topic1", assigns(:topic).title
    assert_not flash.empty?
    assert_redirected_to topics_show_path(id: @topic.forum.id)
  end

  test "should not allow update with invalid data" do
    log_in_as(@user)
    patch :update, id: @topic, topic: { title: "T" }
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
      patch :update, id: @topic, topic: { last_post_id: nil}
      delete :destroy, id: @topic
    end
    assert_redirected_to root_url
  end

  test "should allow destroy when logged in as first post owner" do
    log_in_as(@user4)
    assert_difference 'Topic.count', -1 do
      @post2.topic.update_attributes(:last_post => nil)
      assert_equal @post2.topic.last_post_id, nil
      delete :destroy, id: @post2.topic
    end
    assert_redirected_to topics_show_path(id: @post2.topic.forum.id)
  end

  test "should allow destroy when logged in as admin user" do
    log_in_as(@user)
    assert_difference 'Topic.count', -1 do
      @topic.update_attributes(:last_post => nil)
      assert_equal @topic.last_post_id, nil
      delete :destroy, id: @topic
    end
    assert_redirected_to topics_show_path(id: @topic.forum.id)
  end


end
