class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  after_action :update_topic_after_create, only: [:create]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def update_topic_after_create(post)
    redirect_to url_for(controller: 'topics', 
                        action: 'update_latest_topic_post',
                        last_post_id: post.id,
                        topic_id: post.topic_id) and return

    #redirect_to 'update_latest_topic_post' and return

  end

  def destroy
  end

  private

    def post_params
      params.require(:post).permit(:content)
    end
end
