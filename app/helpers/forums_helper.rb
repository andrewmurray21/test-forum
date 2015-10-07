module ForumsHelper

  def forum_topics_count(forum)
    @forum_topics_count = forum.posts.select(:topic_id).distinct.count
  end

  def forum_posts_count(forum)
    @forum_posts_count = forum.posts.count
  end
end
