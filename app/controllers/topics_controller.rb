class TopicsController < ApplicationController

  def show
    @posts = Topic.find(params[:id]).posts.reverse_order
    @posts = @posts.paginate(page: params[:page], per_page: 5)

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
  
  end

  private

    def topic_params
      params.require(:topic).permit(:title, :first_post_content, :forum_id)
    end

end
