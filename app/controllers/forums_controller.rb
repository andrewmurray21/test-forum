class ForumsController < ApplicationController
  before_action :logged_in_user, only: [:show, :new, :create, :edit, :update, :destroy]
  before_action :admin_user,     only: [:new, :create, :edit, :update, :destroy]

  def show
    @forums = Forum.includes(:topics).order(:created_at).paginate(page: params[:page], per_page: 10)
  end

  def new
    @forum = Forum.new
  end

  def create
    @forum = Forum.new(forum_params)
    if @forum.save
      flash[:success] = "Forum created"
      redirect_to forums_show_path
    else
      render 'new'
    end
  end

  def destroy
    forum_to_delete = Forum.find(params[:id])

    if forum_to_delete.topics
      forum_to_delete.topics.each do |t|
        t.update_attributes(:last_post => nil)
        t.destroy
      end
    end

    if forum_to_delete.destroy
      flash[:success] = "Forum deleted"
      redirect_to forums_show_path
    else
      flash[:success] = "Forum could not be deleted"
      redirect_to forums_show_path
    end
  end

  def edit
    @forum = Forum.find(params[:id])
  end

  def update
    @forum = Forum.find(params[:id])
    if @forum.update_attributes(:title => params["title"])
      flash[:success] = "Forum title updated"
      redirect_to forums_show_path
    else
      flash[:danger] = "Forum title not updated - title invalid (minimum length 3, maximum 100)"
      redirect_to forums_show_path
    end
  end

  private

    def forum_params
      params.require(:forum).permit(:title)
    end

end
