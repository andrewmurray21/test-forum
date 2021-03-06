class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

    # Confirms a logged-in user.
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def correct_user_or_admin_post
      @user = Post.find(params[:id]).user
      redirect_to(root_url) unless current_user?(@user) or current_user.admin?
    end

    def correct_user_or_admin_topic
      @user = Topic.find(params[:id]).posts.order("created_at").last.user
      redirect_to(root_url) unless current_user?(@user) or current_user.admin?
    end
end
