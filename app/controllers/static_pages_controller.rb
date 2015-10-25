class StaticPagesController < ApplicationController
  def home
    @forums = Forum.includes(:topics).paginate(page: params[:page], per_page: 10)
  end

  def help
  end

  def about
  end

  def contact
  end
end
