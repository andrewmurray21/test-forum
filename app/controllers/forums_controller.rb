class ForumsController < ApplicationController

  def show
    forum = Forum.find(params[:id]).topics
    topics_list = Hash.new
    forum.each do |n|
      topics_list[n.id] = n.last_post.created_at
    end

    sorted = topics_list.sort_by{|k, v| v}.reverse
    @forum_ids = sorted.collect {|k, v| k}
    @forum_ids = @forum_ids.paginate(page: params[:page], per_page: 10)
  end

end
