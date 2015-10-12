module StaticPagesHelper

# helpers for main forum page

  def latest(forum)
    @latest = forum.posts.first
  end

  def forum_empty?(forum)
    forum.posts.empty?
  end

  def forum_topics_count(forum)
    @forum_topics_count = forum.posts.select(:topic_id).distinct.count
  end

  def forum_posts_count(forum)
    @forum_posts_count = forum.posts.count
  end

  def get_title(id)
    @topic_title = Topic.find(id).title
  end

  def get_last_post_time(id)
    @topic_time = Topic.find(id).last_post.created_at
  end

  def get_last_post_user(id)
    @topic_poster = Topic.find(id).last_post.user.name
  end 
end
