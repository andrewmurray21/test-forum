require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:one)
    @user2 = users(:two)
    @user4 = users(:four)
    @forum = forums(:Forum1)
    @forum2 = forums(:Forum2)
    @forum4 = forums(:Forum4)
    @forum_1 = forums(:Forum_1)
  end

  test "not logged in homepage layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "title", full_title("Forums Home")

    check_header_and_footer(nil)

    assert_select "a[href=?]", signup_path, 
      text: 'Sign up now!', count: 1
    assert_select "a[href=?]", forums_show_path, 
      text: 'Enter forums!', count: 0

  end

  test "admin logged in homepage layout links" do
    log_in_as(@user)
    get root_path
    assert_template 'static_pages/home'
    assert_select "title", full_title("Forums Home")

    check_header_and_footer(@user)

    assert_select "a[href=?]", signup_path, text: 'Sign up now!', count: 0
    assert_select "a[href=?]", forums_show_path, 
      text: 'Enter forums!', count: 1
  end

  test "non-admin logged in homepage layout links" do
    log_in_as(@user2)
    get root_path
    assert_template 'static_pages/home'
    assert_select "title", full_title("Forums Home")

    check_header_and_footer(@user2)

    assert_select "a[href=?]", signup_path, text: 'Sign up now!', count: 0
    assert_select "a[href=?]", forums_show_path, 
      text: 'Enter forums!', count: 1
  end

  test "new user layout links" do
    get signup_path
    assert_template 'users/new'
    assert_select "title", full_title("Sign up")

    check_header_and_footer(nil)

    # add fields + button check
  end

  test "logging in user layout links" do
    get login_path
    assert_template 'sessions/new'
    assert_select "title", full_title("Log in")

    check_header_and_footer(nil)

    # add field and button check
  end

  test "admin logged in edit layout links" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    assert_select "title", full_title("Edit user")

    check_header_and_footer(@user)

    # add field and button check
  end

  test "non-admin logged in edit layout links" do
    log_in_as(@user2)
    get edit_user_path(@user2)
    assert_template 'users/edit'
    assert_select "title", full_title("Edit user")

    check_header_and_footer(@user2)

    # add field and button check
  end

  test "admin logged in forums home layout links" do
    # login and get forum home
    log_in_as(@user)
    get forums_show_path
    assert_template 'forums/show'

    # check header + footer
    check_header_and_footer(@user)

    # breadcrumb check
    assert_select "a[href=?]", forums_show_path, 
      text: 'Forums Home', count: 1

    # new forum button check
    assert_select "a[href=?]", new_forum_path, 
      text: 'Create a new forum!', count: 1

    # pagination check
    assert_select "div.pagination"

    # first forum content check
    assert_select "a[href=?]", topics_show_path(@forum), 
      text: @forum.title, count: 1
    assert_select "p[class=?]", "#{@forum.id}.info",
      text: "Topics: #{@forum.topics.count}, Posts: #{@forum.posts.count}",
      count: 1
    assert_select "p[class=?]", "#{@forum.id}.latest_topic",
      text: @forum.topics.order("last_post_id").last.title, count: 1
    assert_select "p[class=?]", "#{@forum.id}.latest_user",
      text: "#{@forum.posts.order("created_at").first.user.name}, " +
      time_ago_in_words(@forum.topics.order("last_post_id").last.posts.
      first.created_at) + " ago", count: 1
    assert_select "a[href=?]", user_path(@forum.posts.order("created_at")
      .first.user),
      text: "#{@forum.posts.order("created_at").first.user.name}"

    # empty forum check
    assert_select "a[href=?]", topics_show_path(@forum2), 
      text: @forum2.title, count: 1
    assert_select "p[class=?]", "#{@forum2.id}.info",
      text: "Topics: #{@forum2.topics.count}, Posts: #{@forum2.posts.count}",
      count: 1
    assert_select "p[class=?]", "#{@forum2.id}.no_topics",
      text: "No topics in this forum"    

    # edit/delete forum buttons check
    assert_select "a[data-method=?]", 
      "delete", count: 11 # 10 forums per page, + 1 for logout
    assert_select "input[value=?]", 
      "patch", count: 10 # 10 forums per page
  end

  test "non-admin logged in forums home layout links" do
    # login and get forum home
    log_in_as(@user2)
    get forums_show_path
    assert_template 'forums/show'

    # check header + footer
    check_header_and_footer(@user2)

    # breadcrumb check
    assert_select "a[href=?]", forums_show_path, 
      text: 'Forums Home', count: 1

    # new forum button check
    assert_select "a[href=?]", new_forum_path, 
      text: 'Create a new forum!', count: 0

    # pagination check
    assert_select "div.pagination"

    # first forum content check
    assert_select "a[href=?]", topics_show_path(@forum), 
      text: @forum.title, count: 1
    assert_select "p[class=?]", "#{@forum.id}.info",
      text: "Topics: #{@forum.topics.count}, Posts: #{@forum.posts.count}",
      count: 1
    assert_select "p[class=?]", "#{@forum.id}.latest_topic",
      text: @forum.topics.order("last_post_id").last.title, count: 1
    assert_select "p[class=?]", "#{@forum.id}.latest_user",
      text: "#{@forum.posts.order("created_at").first.user.name}, " +
      time_ago_in_words(@forum.topics.order("last_post_id").last.posts.
      first.created_at) + " ago", count: 1
    assert_select "a[href=?]", user_path(@forum.posts.order("created_at")
      .first.user),
      text: "#{@forum.posts.order("created_at").first.user.name}"

    # empty forum check
    assert_select "a[href=?]", topics_show_path(@forum2), 
      text: @forum2.title, count: 1
    assert_select "p[class=?]", "#{@forum2.id}.info",
      text: "Topics: #{@forum2.topics.count}, Posts: #{@forum2.posts.count}",
      count: 1
    assert_select "p[class=?]", "#{@forum2.id}.no_topics",
      text: "No topics in this forum"
    

    # edit/delete forum buttons check
    assert_select "a[data-method=?]", 
      "delete", count: 1 # 10 forums per page, + 1 for logout
    assert_select "input[value=?]", 
      "patch", count: 0 # 10 forums per page
  end

  test "admin logged in forum topics layout links" do
    # login and get forum home
    log_in_as(@user)
    get topics_show_path(@forum4.id)
    assert_template 'topics/show'

    # check header + footer
    check_header_and_footer(@user)

    # breadcrumb check
    assert_select "a[href=?]", forums_show_path, 
      text: 'Forums Home', count: 1
    assert_select "a[href=?]", topics_show_path(@forum4.id), 
      text: @forum4.title, count: 1

    # new topic button check
    assert_select "a[href=?]", new_topic_path, 
      text: 'Create a new topic!', count: 1

    # pagination check, empty
    assert_select "div.pagination", count: 2

    get topics_show_path(@forum_1.id)

    # pagination check, exists
    assert_select "div.pagination", count: 0

    # first topic content check
    assert_select "a[href=?]", posts_show_path(forum_id: @forum_1.id,
      topic_id: @forum_1.topics.first.id), 
      text: @forum_1.topics.first.title, count: 1
    assert_select "p[class=?]", "#{@forum_1.topics.first.id}.info",
      text: "By: #{@forum_1.topics.first.posts.last.user.name}, " +
      "#{time_ago_in_words(@forum_1.topics.first.posts.last.created_at)}" +
      " ago. Posts: #{@forum_1.topics.first.posts.count}"
    assert_select "p[class=?]", "#{@forum_1.topics.first.id}.latest_post",
      text: "Last Post By: #{@forum_1.topics.first.posts.first.user.name}"
    assert_select "p[class=?]", "#{@forum_1.topics.first.id}.latest_time",
      text:
      "#{time_ago_in_words(@forum_1.topics.first.posts.first.created_at)} ago"

    
    # edit/delete topic buttons check
    assert_select "a[data-method=?]", 
      "delete", count: 11 # 10 forums per page, + 1 for logout
    assert_select "input[value=?]", 
      "patch", count: 10 # 10 forums per page
  end

  test "non-admin logged in forum topics layout links / no topics owned" do
    # login and get forum home
    log_in_as(@user2)
    get topics_show_path(@forum4.id)
    assert_template 'topics/show'

    # check header + footer
    check_header_and_footer(@user2)

    # breadcrumb check
    assert_select "a[href=?]", forums_show_path, 
      text: 'Forums Home', count: 1
    assert_select "a[href=?]", topics_show_path(@forum4.id), 
      text: @forum4.title, count: 1

    # new topic button check
    assert_select "a[href=?]", new_topic_path, 
      text: 'Create a new topic!', count: 1

    # pagination check, empty
    assert_select "div.pagination", count: 2

    get topics_show_path(@forum_1.id)

    # breadcrumb check after changing page
    assert_select "a[href=?]", forums_show_path, 
      text: 'Forums Home', count: 1
    assert_select "a[href=?]", topics_show_path(@forum_1.id), 
      text: @forum_1.title, count: 1

    # pagination check, exists after changing page
    assert_select "div.pagination", count: 0

    # first topic content check
    assert_select "a[href=?]", posts_show_path(forum_id: @forum_1.id,
      topic_id: @forum_1.topics.first.id), 
      text: @forum_1.topics.first.title, count: 1
    assert_select "p[class=?]", "#{@forum_1.topics.first.id}.info",
      text: "By: #{@forum_1.topics.first.posts.last.user.name}, " +
      "#{time_ago_in_words(@forum_1.topics.first.posts.last.created_at)}" +
      " ago. Posts: #{@forum_1.topics.first.posts.count}"
    assert_select "p[class=?]", "#{@forum_1.topics.first.id}.latest_post",
      text: "Last Post By: #{@forum_1.topics.first.posts.first.user.name}"
    assert_select "p[class=?]", "#{@forum_1.topics.first.id}.latest_time",
      text:
      "#{time_ago_in_words(@forum_1.topics.first.posts.first.created_at)} ago"

    # edit/delete topic buttons check
    assert_select "a[data-method=?]", 
      "delete", count: 1 # only 1 for logout
    assert_select "input[value=?]", 
      "patch", count: 0 # 0 - none owned
  end

  test "non-admin logged in forum topics layout links / topics owned" do

    # login and get forum home
    log_in_as(@user4)
    get topics_show_path(@forum.id)
    assert_template 'topics/show'

    # first topic content check
    assert_select "a[href=?]", posts_show_path(forum_id: @forum.id,
      topic_id: @forum.topics.first.id), 
      text: @forum.topics.first.title, count: 1
    assert_select "p[class=?]", "#{@forum.topics.first.id}.info",
      text: "By: #{@forum.topics.first.posts.last.user.name}, " +
      "#{time_ago_in_words(@forum.topics.first.posts.last.created_at)}" +
      " ago. Posts: #{@forum.topics.first.posts.count}"
    assert_select "p[class=?]", "#{@forum.topics.first.id}.latest_post",
      text: "Last Post By: #{@forum.topics.first.posts.first.user.name}"
    assert_select "p[class=?]", "#{@forum.topics.first.id}.latest_time",
      text:
      "#{time_ago_in_words(@forum.topics.first.posts.first.created_at)} ago"

    # edit/delete topic buttons check
    assert_select "a[data-method=?]", 
      "delete", count: 2 # 1 topic + 1 for logout
    assert_select "input[value=?]", 
      "patch", count: 1
  end


  test "admin logged in topic posts layout links" do
    # login and get forum home
    log_in_as(@user)
    get posts_show_path(forum_id: @forum.id, topic_id: @forum.topics.first.id)
    assert_template 'posts/show'

    # check header + footer
    check_header_and_footer(@user)

    # breadcrumb check
    assert_select "a[href=?]", forums_show_path, 
      text: 'Forums Home', count: 1
    assert_select "a[href=?]", topics_show_path(@forum.id), 
      text: @forum.title, count: 1
    assert_select "a[href=?]",
      posts_show_path(forum_id: @forum.id, topic_id: @forum.topics.first.id), 
      text: @forum.topics.first.title, count: 1

    # pagination check, empty
    assert_select "div.pagination", count: 2

    get posts_show_path(forum_id: @forum.id, topic_id: @forum.topics.second.id)

    # pagination check, exists
    assert_select "div.pagination", count: 0

    # first post content check
    assert_select 'img.gravatar', more_than: 1 # already 1 in header
    assert_select "a[href=?]", user_path(@forum.topics.second.posts.first.user), 
      text: @forum.topics.second.posts.first.user.name, count: 1
    assert_select "p[class=?]", 
      "#{@forum.topics.second.posts.first.id}.created",
      text:"#{time_ago_in_words@forum.topics.second.posts.first.created_at}"+
      " ago"
    assert_select "p[class=?]", 
      "#{@forum.topics.second.posts.first.id}.content",
      text: "#{@forum.topics.second.posts.first.content}"
    
    # edit/delete topic buttons check
    assert_select "a[data-method=?]", 
      "delete", count: 4 # 3 post on page, + 1 for logout
    assert_select "input[value=?]", 
      "patch", count: 3

    # new post form
#    assert_select "new_post" do
#      assert_select 
#    end
  end


end
