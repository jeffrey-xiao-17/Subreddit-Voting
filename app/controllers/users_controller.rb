class UsersController < ApplicationController
  before_action :authenticate_user, except: [:new, :create]
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :check_user, only: [:edit, :update, :destroy]

  # GET /users
  # GET /users.json
  def index
    @users = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.password = user_params[:password_hash]

    @user.avatar_img.attach(io: open("app/assets/images/RedditAvatars/#{rand(1..500)}.png"), filename: "avatar.png", content_type: "image/png") if user_params[:avatar_img] == nil
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    liked_save = @user.liked_comments
    disliked_save = @user.disliked_comments
    @user.assign_attributes(user_params)
    @user.password = user_params[:password_hash]
    @user.avatar_img.attach(io: open("app/assets/images/RedditAvatars/#{rand(1..500)}.png"), filename: "avatar.png", content_type: "image/png") if user_params[:avatar_img] == nil
    @user.liked_comments = liked_save
    @user.disliked_comments = disliked_save
    respond_to do |format|
      if @user.save
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      session[:user_id] = nil         
      format.html { redirect_to '/login', notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def view_followships_feed
    @user = User.find(params[:user_id])
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def user_params
      params.require(:user).permit(:avatar_img, :first_name, :last_name, :username, :password_hash, :is_mod, :liked_comments, :disliked_comments)
    end

    def check_user
      redirect_to "/users" unless set_user == current_user
    end

end
