class FollowshipsController < ApplicationController
  before_action :authenticate_user

  def add_follow
    @follower = User.find(params[:follower_id])
    @following = User.find(params[:following_id])
    @follower.followers << @following
    redirect_to users_path
  end

  def delete_follow
    @follower = User.find(params[:follower_id])
    @following = User.find(params[:following_id])
    @follower.followers.delete(@following)
    redirect_to users_path
  end

  def view_followships
    @user = User.find(params[:user_id])
  end
end