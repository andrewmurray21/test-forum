class ForumsController < ApplicationController

  def show
    @forums = Forum.includes(:topics).paginate(page: params[:page], per_page: 10)
  end

end
