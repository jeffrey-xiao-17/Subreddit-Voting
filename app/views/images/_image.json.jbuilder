json.extract! image, :id, :subreddit_id, :caption, :upvotes, :created_at, :updated_at
json.url image_url(image, format: :json)
