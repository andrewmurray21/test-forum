require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
  end

  test "not logged in homepage layout links" do
    #not logged in
    get root_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select 'a[href=?]', '#', text: 'Account', count: 0
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    #sign-up button, no logged in text
  end

  test "admin logged in homepage layout links" do
    #login
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", users_path # only for admin
    assert_select 'a[href=?]', '#', text: @user.name
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    #logged in text, no sign-up button
  end

  test "new user layout links" do
    get signup_path
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 0
    assert_select "a[href=?]", users_path, count: 0
    assert_select 'a[href=?]', '#', text: 'Account', count: 0
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  test "logged in edit layout links" do
    #login
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

end
