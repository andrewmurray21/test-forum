require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @user2 = users(:two)
    @forum = forums(:one)
  end

  test "not logged in homepage layout links" do
    get root_path
    assert_select "a[href=?]", signup_path, text: 'Sign up now!', count: 1
    assert_select "a[href=?]", forums_show_path, 
      text: 'Enter forums!', count: 0
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select 'a[href=?]', '#', text: 'Account', count: 0
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "admin logged in homepage layout links" do
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", signup_path, text: 'Sign up now!', count: 0
    assert_select "a[href=?]", forums_show_path, 
      text: 'Enter forums!', count: 1
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path # only for admin
    assert_select 'a[href=?]', '#', text: @user.name
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "non-admin logged in homepage layout links" do
    log_in_as(@user2)
    get root_path
    assert_select "a[href=?]", signup_path, text: 'Sign up now!', count: 0
    assert_select "a[href=?]", forums_show_path, 
      text: 'Enter forums!', count: 1
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select 'a[href=?]', '#', text: @user2.name
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "new user layout links" do
    get signup_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select 'a[href=?]', '#', count: 0 #user name
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "logging in user layout links" do
    get login_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select 'a[href=?]', '#', count: 0 #user name
    assert_template 'sessions/new'
    assert_select "title", full_title("Log in")
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "admin logged in edit layout links" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path
    assert_select 'a[href=?]', '#', text: @user.name
    assert_template 'users/edit'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "non-admin logged in edit layout links" do
    log_in_as(@user2)
    get edit_user_path(@user2)
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path, count: 0
    assert_select 'a[href=?]', '#', text: @user2.name
    assert_template 'users/edit'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "admin logged in forums home layout links" do
    log_in_as(@user)
    get forums_show_path
    assert_select "a[href=?]", new_forum_path, 
      text: 'Create a new forum!', count: 1
    assert_select "a[href=?/#{@forum.id}][data-method='delete']", 
      forums_path
    assert_select "form[action=?/#{@forum.id}][input[value='patch']]", 
      forums_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path
    assert_select 'a[href=?]', '#', text: @user.name
    assert_template 'forums/show'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

end
