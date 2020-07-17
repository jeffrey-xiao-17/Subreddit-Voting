class Image < ApplicationRecord
  has_one_attached :picture_img
  has_one_attached :thumbnail_img
  has_many :comments, dependent: :destroy
  belongs_to :subreddit
  validates :caption, :upvotes, presence: true

  def get_content_type
    picture_img.content_type
  end
end
