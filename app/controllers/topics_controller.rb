class TopicsController < ApplicationController

  before_action :logged_in_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :correct_user_or_admin_topic,   only: [:edit, :update, :destroy]

  def show
    @current_forum = Forum.find(params[:id])

    @topics = Topic.includes(:last_post, :posts).where(forum_id: params[:id])
                .order("last_post_id").reverse
                .paginate(page: params[:page], per_page: 10)
  end

  def new
    @forum_id = Forum.find(params["id"]).id
    @topic = Forum.find(params["id"]).topics.build
  end

  def create
    @forum_id = Forum.find(params["topic"]["forum_id"]).id
    @topic = Forum.find(params["topic"]["forum_id"]).topics.build(topic_params)

    if @topic.save
      @post = current_user.posts.where(topic_id: @topic.id).build(
         content: @topic.first_post_content)
      if @post.save
        @topic.update_columns(last_post_id: @post.id)
        flash[:success] = "Topic and first post created!"
        redirect_to topics_show_path(@forum_id)
      else
        @topic.destroy
        render 'new'
      end
    else
      render 'new'
    end
  end

  def destroy
    topic_to_delete = Topic.find(params[:id])
    topic_to_delete.update_attributes(:last_post => nil)
    topic_to_delete.destroy
    flash[:success] = "Topic deleted"
    redirect_to topics_show_path(topic_to_delete.forum.id)
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(:title => params["title"])
      flash[:success] = "Topic updated"
      redirect_to topics_show_path(@topic.forum.id)
    else
      flash[:danger] = "Topic not updated - title invalid (minimum length 3, maximum 100)"
      redirect_to topics_show_path(@topic.forum.id)
    end
  end

  private

    def topic_params
      params.require(:topic).permit(:title, :first_post_content, :forum_id)
    end

end
