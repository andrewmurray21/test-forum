class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @post = current_user.posts.where(topic_id: params["post"]["topic_id"]).build(post_params)
    if @post.save
      Topic.find(params["post"]["topic_id"]).update_columns(last_post_id: @post.id)
      flash[:success] = "Post created!"
      redirect_to :back
    else
      flash[:alert] = "Post not created!"
      redirect_to :back
    end
  end

  def destroy
  end

  private

    def post_params
      params.require(:post).permit(:content, :topic_id)
    end
end
