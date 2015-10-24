class ForumsController < ApplicationController

  def show
    @current_forum = Forum.find(params[:id])

    @topics = Topic.includes(:last_post, :posts).where(forum_id: params[:id])
                .order("last_post_id").reverse
                .paginate(page: params[:page], per_page: 10)
  end

end
