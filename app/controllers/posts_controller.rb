class PostsController < ApplicationController
  before_action :logged_in_user, only: [:show, :create, :edit, :update, :destroy]

  def show
    @current_topic = Topic.includes(:posts).find(params[:topic_id])
    @posts = @current_topic.posts.paginate(page: params[:page], per_page: 10)

    @posts_form = current_user.posts.where(topic_id: params[:topic_id]).build
    @post_topic = Topic.find(params[:topic_id]).id
  end

  def create
    @post = current_user.posts.where(topic_id: params["post"]["topic_id"]).build(post_params)
    if @post.save
      if Topic.find(params["post"]["topic_id"]).update_columns(last_post_id: @post.id)
        flash[:success] = "Post created!"
        redirect_to :back
      else
        @post.destroy
        flash[:danger] = "Post not created"
        redirect_to :back
      end
    else
      flash[:danger] = "Post not created - content invalid (minimum 3 
        characters, maximum 1000)!"
      redirect_to :back
    end
  end

  def destroy
    topic = Topic.find_by(last_post_id: params[:id])
    if topic
      forum_id = topic.forum.id
      topic.update_columns(last_post_id: nil)
      if !topic.save
        flash[:danger] = "Post could not be deleted"
        redirect_to :back
      end
    end

    Post.find(params[:id]).destroy

    if topic && topic.posts.count == 0
      topic.destroy
      flash[:success] = "Post and topic deleted"
      redirect_to topics_show_path(forum_id)
    elsif topic
      topic.update_columns(last_post_id: topic.posts.first.id)
      if topic.save
        flash[:success] = "Post deleted"
        redirect_to :back
      else
        flash[:danger] = "Post could not be deleted"
        redirect_to :back
      end
    else
      flash[:success] = "Post deleted"
      redirect_to :back
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update_attributes(:content => params["content"])
      flash[:success] = "Post updated"
      redirect_to :back
    else
      flash[:danger] = "Post not created - content invalid (minimum length 3 
        characters, maximum 1000)!"
      redirect_to :back
    end
  end

  private

    def post_params
      params.require(:post).permit(:content, :topic_id)
    end

end
