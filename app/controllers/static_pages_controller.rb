class StaticPagesController < ApplicationController
  def home
    #@post = current_user.posts.build if logged_in?
    @forums = Forum.all
    #@last_topic ???
    #@last_post_by ???
    #@last_post_time ???
    
  end

  def help
  end

  def about
  end

  def contact
  end
end
