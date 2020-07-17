class SubredditsController < ApplicationController
  before_action :authenticate_user
  before_action :set_subreddit, only: [:show, :edit, :update, :destroy]
  before_action :check_mod, only: [:edit, :destroy]
  

  # GET /subreddits
  # GET /subreddits.json
  def index
    @subreddits = Subreddit.all
  end

  # GET /subreddits/1
  # GET /subreddits/1.json
  def show
  end

  # GET /subreddits/new
  def new
    @subreddit = Subreddit.new
  end

  # GET /subreddits/1/edit
  def edit
  end

  # POST /subreddits
  # POST /subreddits.json
  def create
    @subreddit = Subreddit.new(subreddit_params)
    @subreddit.total_upvotes = 0
    respond_to do |format|
      if @subreddit.save
        @subreddit.query_for_images
        @subreddit.adjust_description
        format.html { redirect_to @subreddit, notice: 'Subreddit was successfully created.' }
        format.json { render :show, status: :created, location: @subreddit }
      else
        format.html { render :new }
        format.json { render json: @subreddit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /subreddits/1
  # PATCH/PUT /subreddits/1.json
  def update
    respond_to do |format|
      if @subreddit.update(subreddit_params)
        @subreddit.adjust_description
        format.html { redirect_to @subreddit, notice: 'Subreddit was successfully updated.' }
        format.json { render :show, status: :ok, location: @subreddit }
      else
        format.html { render :edit }
        format.json { render json: @subreddit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /subreddits/1
  # DELETE /subreddits/1.json
  def destroy
    @subreddit.destroy
    respond_to do |format|
      format.html { redirect_to subreddits_url, notice: 'Subreddit was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_subreddit
      @subreddit = Subreddit.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def subreddit_params
      params.require(:subreddit).permit(:name, :description, :total_upvotes)
    end

    def check_mod
      redirect_to "/subreddits" unless current_user.is_mod
    end
end
