class TopicsController < ApplicationController

  def update_latest_topic_post
    Topic.find(params[:topic_id]).update_columns(last_post_id: params[:last_post_id])
  end

end
