json.extract! comment, :id, :image_id, :user_id, :caption, :upvotes, :created_at, :updated_at
json.url comment_url(comment, format: :json)
