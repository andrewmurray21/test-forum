class TopicsController < ApplicationController

  def show
    @posts = Topic.find(params[:id]).posts
    @posts = @posts.paginate(page: params[:page], per_page: 5)

    @posts_form = current_user.posts.where(topic_id: params[:id]).build
    @post_topic = Topic.find(params[:id]).id
  end

end
