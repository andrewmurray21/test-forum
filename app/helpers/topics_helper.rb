module TopicsHelper

  def last_updated_topic_title(forum)
    @last_updated_topic = forum.posts.last.topic.title
  end

  def last_updated_topic_user(forum)
    @last_updated_topic = forum.posts.last.user.name
  end

  def last_updated_topic_time(forum)
    @last_updated_topic = forum.posts.last.created_at
  end

  def forum_empty?(forum)
    forum.posts.empty?
  end
end
