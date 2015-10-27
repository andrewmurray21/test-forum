class ForumsController < ApplicationController
  before_action :logged_in_user, only: [:show]

  def show
    @forums = Forum.includes(:topics).paginate(page: params[:page], per_page: 10)
  end

end
