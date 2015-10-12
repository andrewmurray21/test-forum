class StaticPagesController < ApplicationController
  def home
    #@post = current_user.posts.build if logged_in?
    all_forums = Forum.all
    @forums_main_hash = Hash.new
    all_forums.each do |f|
      @forums_main_hash[f.title] = Hash.new
      @forums_main_hash[f.title]["forum_id"] = f.id
      @forums_main_hash[f.title]["topics_count"] = 
                                    f.posts.select(:topic_id).distinct.count
      @forums_main_hash[f.title]["posts_count"] =
                                    f.posts.count
      if !f.posts.empty?
        @forums_main_hash[f.title]["latest_title"] = 
                                    f.posts.first.topic.title
        @forums_main_hash[f.title]["latest_user"] = 
                                    f.posts.first.user.name
        @forums_main_hash[f.title]["latest_date"] = 
                                    f.posts.first.created_at
      else
        @forums_main_hash[f.title]["latest_title"] = 
                                    "No posts in this forum"
        @forums_main_hash[f.title]["latest_user"] = nil
        @forums_main_hash[f.title]["latest_date"] = nil
      end
     end

    @forums_keys = @forums_main_hash.keys.paginate(page: params[:page], per_page: 5)
    
  end

  def help
  end

  def about
  end

  def contact
  end
end
