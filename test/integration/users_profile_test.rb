require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:one)
  end

  test "profile display" do
    log_in_as(@user)
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: "#{@user.name}"
    assert_select 'h5', text: "#{@user.email}"
    assert_select 'h1>img.gravatar'
    assert_match @user.posts.count.to_s, response.body
    assert_select 'div.pagination'
    @user.posts.paginate(page: 1, per_page: 10).each do |post|
      assert_match post.content, response.body
    end
  end

end
