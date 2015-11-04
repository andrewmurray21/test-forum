class PostsController < ApplicationController
  before_action :logged_in_user, only: [:show, :create, :update, :destroy]
  before_action :correct_user_or_admin_post,   only: [:update, :destroy]

  def show
    @current_topic = Topic.includes(:posts).find(params[:topic_id])
    @posts = @current_topic.posts.paginate(page: params[:page], per_page: 10)

    @posts_form = current_user.posts.where(topic_id: params[:topic_id]).build
    @post_topic = Topic.find(params[:topic_id]).id
  end

  def create
    @post = current_user.posts.where(topic_id: params["post"]["topic_id"]).build(post_params)
    if @post.save
      Topic.find(params["post"]["topic_id"]).update_columns(last_post_id: @post.id)
      flash[:success] = "Post created!"
      redirect_to posts_show_path(forum_id: @post.topic.forum.id, 
        topic_id: params["post"]["topic_id"])
    else
      flash[:danger] = "Post not created - content invalid (minimum 3 
        characters, maximum 1000)!"
      redirect_to posts_show_path(forum_id: @post.topic.forum.id, 
          topic_id: params["post"]["topic_id"])
    end
  end

  def destroy
    post = Post.find(params[:id])
    topic = Topic.find_by(last_post_id: params[:id])
    first_post = post.topic.posts.order("created_at").last
    
    if topic or first_post == post
      post.topic.update_columns(last_post_id: nil)
      post.topic.save
    end

    post.destroy

    if first_post == post
      forum_id = post.topic.forum.id
      post.topic.destroy
      flash[:success] = "Post and topic deleted"
      redirect_to topics_show_path(forum_id)
    elsif topic
      topic.update_columns(last_post_id: topic.posts.first.id)
      topic.save
      flash[:success] = "Post deleted"
      redirect_to posts_show_path(forum_id: topic.forum.id, 
          topic_id: topic.id)
    else
      flash[:success] = "Post deleted"
      redirect_to posts_show_path(forum_id: post.topic.forum.id, 
          topic_id: post.topic.id)
    end
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(post_params)
      flash[:success] = "Post updated"
      redirect_to posts_show_path(forum_id: @post.topic.forum.id, 
          topic_id: @post.topic.id)
    else
      flash[:danger] = "Post not updated - content invalid (minimum length 3 
        characters, maximum 1000)!"
      redirect_to posts_show_path(forum_id: @post.topic.forum.id, 
          topic_id: @post.topic.id)
    end
  end

  private

    def post_params
      params.require(:post).permit(:content, :topic_id)
    end

end
