module TopicsHelper

  def forum_empty?(forum)
    forum.posts.empty?
  end

end
