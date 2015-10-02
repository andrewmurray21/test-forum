require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin     = users(:one)
    @non_admin = users(:two)
  end

  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.where(activated: true).paginate(page: 1, per_page: 10)
    first_page_of_users.each do |user|
      puts @response.body
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "only show activated users in index" do
    log_in_as @admin
    get users_path
    assert_match @non_admin.name, response.body
    @non_admin.toggle!(:activated)
    get users_path
    assert_no_match @non_admin.name, response.body
    @non_admin.toggle!(:activated)
  end
  
  test "should redirect show when user not activated" do
    log_in_as(@admin)
    get user_path(@non_admin)
    assert_template 'users/show'
    @non_admin.toggle!(:activated)
    get user_path(@non_admin)
    assert_redirected_to root_url
    @non_admin.toggle!(:activated)
  end
end
