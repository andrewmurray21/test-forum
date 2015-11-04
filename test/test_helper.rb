ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!
include ActionView::Helpers::DateHelper

require 'simplecov'
SimpleCov.start do
  add_filter '/bin/'
  add_filter '/config/'
  add_filter '/lib/'
  add_filter '/log/'
  add_filter '/project/'
  add_filter '/public/'
  add_filter '/tmp/'
  add_filter '/test/'
  add_filter '/vendor/'
 
  add_group 'Controllers', 'app/controllers'
  add_group 'Mailers', 'app/mailers'
  add_group 'Models', 'app/models'
  add_group 'Helpers', 'app/helpers'
end

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical
  # order.
  fixtures :all
  include ApplicationHelper


  # Returns true if a test user is logged in.
  def is_logged_in?
    !session[:user_id].nil?
  end

  # Logs in a test user.
  def log_in_as(user, options = {})
    password    = options[:password]    || 'password'
    remember_me = options[:remember_me] || '1'
    if integration_test?
      post login_path, session: { email:       user.email,
                                  password:    password,
                                  remember_me: remember_me }
    else
      session[:user_id] = user.id
    end
  end

  def log_out_as(user)
    session[:user_id] = nil
  end

  def check_header_and_footer(user)
    assert_select "a[href=?]", root_path, 
      count: 1
    if user
      assert_select "a[href=?]", login_path, 
        text: "Log in",
        count: 0
      assert_select "a[href=?]", "#", 
        text: user.name,
        count: 1
      assert_select "img[class=?]", "gravatar", 
        less_than: 3 # at least 1, + 1 for edit page
      assert_select 'a[href=?]', user_path(user),
        text: "Profile", 
        count: 1
      assert_select 'a[href=?]', edit_user_path(user), 
        text: "Settings",
        count: 1
      assert_select "a[href=?]", users_path,
        text: "Users",
        count: user.admin ? 1 : 0
      assert_select "a[href=?]", logout_path,
        text: "Log out",
        count: 1
    else
      assert_select "a[href]",
        text: "Log in", 
        count: 1
      assert_select "img[class=?]", "gravatar", 
        count: 0
      assert_select 'a[href]',
        text: "Profile", 
        count: 0
      assert_select 'a[href]', 
        text: "Settings",
        count: 0
      assert_select "a[href]",
        text: "Users",
        count: 0
      assert_select "a[href]",
        text: "Log out",
        count: 0
    end

    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
  end

  private

    # Returns true inside an integration test.
    def integration_test?
      defined?(post_via_redirect)
    end

end
