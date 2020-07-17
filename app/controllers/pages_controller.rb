class PagesController < ApplicationController
  before_action :authenticate_user, except: [:home]

  def home
  end

  # GET
  def vote
    # if params[:subreddit_id] != nil
    #   @subreddit = Subreddit.find(params[:subreddit_id])
    #   @subreddit
    # end
    # binding.pry
    # if params[:sub] != nil && !(current_user.subreddits.include? Subreddit.find(params[:sub]))
    #   binding.pry
    #   redirect_to "\vote?"
    # end
  end
  
  # GET
  def statistics
  end

  # POST
  def cast_vote
    @subreddit = Subreddit.find(params[:subreddit_id])
    @image = @subreddit.images.find(params[:image_id])
    @image.upvotes = @image.upvotes + 1
    @image.save
    @subreddit.total_upvotes = @subreddit.total_upvotes + 1
    @subreddit.save
    if params[:sub] == "all"
      redirect_to '/vote'
    else
      redirect_to "/vote?sub=#{params[:sub]}"
    end
    @subreddit
  end
end