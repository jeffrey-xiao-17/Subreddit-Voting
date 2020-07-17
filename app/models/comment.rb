class Comment < ApplicationRecord
  belongs_to :image
  belongs_to :user
  validate :cap_exists

  def cap_exists
    if caption == nil || caption.length == 0
      redirect_to subreddit_image_path(Image.find(self.image_id).subreddit.id, self.image_id)
      return false
    end
    true
  end
end
