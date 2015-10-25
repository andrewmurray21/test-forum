class PostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

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
      redirect_to :back
    else
      flash[:alert] = "Post not created!"
      redirect_to :back
    end
  end

  def destroy
    Post.find(params[:id]).destroy
    flash[:success] = "Post deleted"
    redirect_to :back
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
      render 'edit'
    end
  end

  private

    def post_params
      params.require(:post).permit(:content, :topic_id)
    end

end
