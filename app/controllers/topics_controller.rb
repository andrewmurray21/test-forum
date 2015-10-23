class TopicsController < ApplicationController

  def show
    @posts = Topic.find(params[:id]).posts
    @posts = @posts.paginate(page: params[:page], per_page: 10)

    @posts_form = current_user.posts.where(topic_id: params[:id]).build
    @post_topic = Topic.find(params[:id]).id
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
        redirect_to "/forums/#{@forum_id}"
      else
        flash[:alert] = "Empty topic created!"
        redirect_to root_path
      end
    else
      flash[:alert] = "Topic not created!"
      redirect_to root_path
    end
  end

  def destroy
    topic_to_delete = Topic.find(params[:id])
    topic_to_delete.update_attributes(:last_post => nil)
    topic_to_delete.destroy
    flash[:success] = "Topic deleted"
    redirect_to :back
  end

  def edit
    @topic = Topic.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(:title => params["title"])
      flash[:success] = "Topic updated"
      redirect_to :back
    else
      render 'edit'
    end
  end

  private

    def topic_params
      params.require(:topic).permit(:title, :first_post_content, :forum_id)
    end

end
