class RegistrationsController < ApplicationController
  before_action :authenticate_user
  before_action :set_subreddit
  before_action :set_user
  before_action :check_user

  def add_subreddit
    @subreddit.users << @user if !@subreddit.users.include?(@user)
    redirect_to @user
  end

  def drop_subreddit
    @subreddit.users.delete(@user) if @subreddit.users.include?(@user)
    redirect_to @user
  end

  private
  
  def set_subreddit
    @subreddit = Subreddit.find(params[:subreddit_id])
  end

  def set_user
    @user = User.find(params[:user_id])
  end

  def check_user
    redirect_to "/users" unless set_user == current_user
  end
end