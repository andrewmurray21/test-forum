require 'test_helper'

class ForumsControllerTest < ActionController::TestCase

  def setup
    @forum = forums(:one)
    @user = users(:one)
    @other_user = users(:two)
  end

  test "should get forum home" do
    log_in_as(@user)
    get :show
    assert_response :success
  end

  test "should redirect forum home when not logged in" do
    get :show
    assert_redirected_to login_url
  end

  test "should get new" do
    log_in_as(@user)
    get :new
    assert_response :success
  end

  test "should redirect new when not logged in" do
    get :new
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect new when not logged in as admin" do
    log_in_as(@other_user)
    get :new
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should allow create" do
    log_in_as(@user)
    assert_difference 'Forum.count', +1 do
      post :create, forum: { title: "forum1" }
    end
    assert_redirected_to forums_show_url
  end

  test "should redirect create when not logged in" do
    assert_no_difference 'Forum.count' do
      post :create, forum: { title: "forum1" }
    end
    assert_redirected_to login_url
  end

  test "should redirect create when not logged in as admin" do
    log_in_as(@other_user)
    assert_no_difference 'Forum.count' do
      post :create, forum: { title: "forum1" }
    end
    assert_redirected_to root_url
  end

  test "should redirect edit when not logged in" do
    get :edit, id: @forum
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect edit when not logged in as admin" do
    log_in_as(@other_user)
    get :edit, id: @forum
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should redirect update when not logged in" do
    patch :update, id: @forum, forum: { title: "new" }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "should redirect update when logged in as non-admin user" do
    log_in_as(@other_user)
    patch :update, id: @forum, forum: { title: "new" }
    assert flash.empty?
    assert_redirected_to root_url
  end

  test "should allow update when logged in as admin user" do
    log_in_as(@user)
    patch :update, id: @forum, forum: { title: "new" }
    assert_not flash.empty?
    assert_redirected_to forums_show_path
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Forum.count' do
      delete :destroy, id: @forum
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'Forum.count' do
      delete :destroy, id: @forum
    end
    assert_redirected_to root_url
  end

  test "should allow destroy when logged in as admin user" do
    log_in_as(@user)
    assert_difference 'Forum.count', -1 do
      delete :destroy, id: @forum
    end
    assert_redirected_to forums_show_path
  end
end
