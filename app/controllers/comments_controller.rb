class CommentsController < ApplicationController
  before_action :authenticate_user
  skip_before_action :verify_authenticity_token
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :destroy]

  # GET /comments
  # GET /comments.json
  def index
    redirect_to subreddits_path
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
    redirect_to subreddit_image_path(@comment.image.subreddit.id, @comment.image.id)
  end

  # GET /comments/new
  def new
    @subreddit = Subreddit.find(params[:subreddit_id])
    @image = @subreddit.images.find(params[:image_id])
    @comment = @image.comments.build
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    @subreddit = Subreddit.find(params[:subreddit_id])
    @image = @subreddit.images.find(params[:image_id])
    if comment_params["caption"] == ""
      redirect_to subreddit_image_path(@subreddit.id, @image.id)
    else
      @comment = @image.comments.build(comment_params)
      @comment.user = current_user
      @comment.upvotes = 0
      respond_to do |format|
        if @comment.save
          format.html { redirect_to subreddit_image_path(@subreddit.id, @image.id), notice: 'Comment was successfully created.' }
          format.json { render :show, status: :created, location: @comment }
        else
          format.html { render :new }
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    sub_id = @comment.image.subreddit.id
    image_id = @comment.image.id
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to subreddit_image_path(sub_id, image_id), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    sub_id = @comment.image.subreddit.id
    image_id = @comment.image.id
    @comment.destroy
    respond_to do |format|
      format.html { redirect_to subreddit_image_path(sub_id, image_id), notice: 'Comment was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote_comment
    @comment = Subreddit.find(params[:subreddit_id]).images.find(params[:image_id]).comments.find(params[:comment_id])

    if !(current_user.liked_comments.include? @comment.id)
      @comment.upvotes = @comment.upvotes + 1
      current_user.liked_comments << @comment.id
    else
      @comment.upvotes = @comment.upvotes - 1
      current_user.liked_comments.delete @comment.id
    end
    
    if current_user.disliked_comments.include? @comment.id
      current_user.disliked_comments.delete @comment.id
      @comment.upvotes = @comment.upvotes + 1
    end

    current_user.save
    @comment.save
    redirect_to "/subreddits/#{params[:subreddit_id]}/images/#{params[:image_id]}"
  end

  def downvote_comment
    @comment = Subreddit.find(params[:subreddit_id]).images.find(params[:image_id]).comments.find(params[:comment_id])
    
    if current_user.liked_comments.include? @comment.id
      @comment.upvotes = @comment.upvotes - 1
      current_user.liked_comments.delete @comment.id
    end

    if !(current_user.disliked_comments.include? @comment.id)
      @comment.upvotes = @comment.upvotes - 1
      current_user.disliked_comments << @comment.id
    else
      @comment.upvotes = @comment.upvotes + 1
      current_user.disliked_comments.delete @comment.id
    end
    
    current_user.save
    @comment.save
    redirect_to "/subreddits/#{params[:subreddit_id]}/images/#{params[:image_id]}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def comment_params
      params.require(:comment).permit(:image_id, :user_id, :caption, :upvotes)
    end

    def check_user
      redirect_to "/subreddits/#{@comment.image.subreddit.id}/images/#{@comment.image.id}" unless @comment.user == current_user
    end
end
