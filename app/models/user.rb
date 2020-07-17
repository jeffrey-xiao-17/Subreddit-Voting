require 'bcrypt'
include BCrypt
class User < ApplicationRecord
  has_many :passive_followships, class_name: "Followship", foreign_key: "following_id", dependent: :destroy
  has_many :followers, through: :passive_followships

  has_many :active_followships, class_name: "Followship", foreign_key: "follower_id", dependent: :destroy
  has_many :followings, through: :active_followships

  has_many :registrations, dependent: :destroy
  has_many :subreddits, through: :registrations
  has_many :comments, dependent: :destroy
  has_one_attached :avatar_img
  validates :first_name, :last_name, :username, :password_hash, presence: true
  validates :password_hash, length: { minimum: 2 }
  validates :username, uniqueness: true

  def full_name
    "#{first_name} #{last_name}"
  end

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end

  def create
    @user = User.new(params[:user])
    @user.password = params[:password]
    @user.save!
  end

  def login
    @user = User.find_by_email(params[:email])
    if @user.password == params[:password]
      give_token
    else
      redirect_to home_url
    end
  end
end
