require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  def setup
    @post = posts(:Post1)
    @post2 = posts(:Post2)
    @forum = forums(:Forum1)
    @topic = topics(:Topic1)
    @user = users(:one)
    @unactivated_user = users(:three)
  end
 
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should re-render page when incorrect password used when logging in" do
    post :create, session: { email: @user.email, password: "wrong" }
    assert_not flash.empty?
    assert_equal "Invalid email/password combination", flash[:danger]
    assert_response :success
  end

  test "should re-render page when blank password used when logging in" do
    post :create, session: { email: @user.email, password: "" }
    assert_not flash.empty?
    assert_equal "Invalid email/password combination", flash[:danger]
    assert_response :success
  end

  test "should re-render page when invalid password used when logging in" do
    post :create, session: { email: @user.email, password: "123456789" }
    assert_not flash.empty?
    assert_equal "Invalid email/password combination", flash[:danger]
    assert_response :success
  end

  test "should login with correct details" do
    post :create, session: { email: @user.email, password: 'password' }
    assert_redirected_to forums_show_url
  end

  test "should redirect login when user not authenticated" do
    post :create, session: { email: @unactivated_user.email, password: 'password' }
    assert_not flash.empty?
    message = "Account not activated. "
    message += "Check your email for the activation link."
    assert_equal message, flash[:warning]
    assert_redirected_to root_url
  end

  test "should login with correct details and remember" do
    post :create, session: { email: @user.email, password: 'password',
      remember_me: '1' }
    assert_equal @user.id, cookies.permanent.signed[:user_id]
    assert_redirected_to forums_show_url
  end

  test "should login with correct details and don't remember" do
    post :create, session: { email: @user.email, password: 'password' }
    assert_not_equal @user.id, cookies.permanent.signed[:user_id]
    assert_redirected_to forums_show_url
  end

  test "should redirect destroy when logged in" do
    log_in_as(@user)
    delete :destroy, id: @user
    assert_redirected_to root_url
  end

  test "should redirect destroy even when not logged in" do
    delete :destroy
    assert_redirected_to root_url
  end

  test "should reset remember cookie when logging out" do
    post :create, session: { email: @user.email, password: 'password',
      remember_me: '1' }
    assert_equal @user.id, cookies.permanent.signed[:user_id]
    assert_redirected_to forums_show_url
    delete :destroy
    assert_equal nil, cookies.permanent.signed[:user_id]
    assert_redirected_to root_url
  end

end
