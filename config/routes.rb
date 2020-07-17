Rails.application.routes.draw do
  root to: 'pages#home'

  resources :users
  resources :subreddits do
    resources :images do 
      resources :comments
    end
  end

  get '/login', to:'sessions#new'
  post '/login', to:'sessions#create'
  delete '/login', to:'sessions#destroy'

  get '/vote', to:'pages#vote'
  get '/vote?sub=:subreddit_id', to:'pages#vote'
  post '/cast_vote/:subreddit_id/:image_id', to:'pages#cast_vote'

  get '/statistics', to:'pages#statistics'
  get '/statistics?sub=:subreddit_id', to:'pages#statistics'

  post '/subreddits/:subreddit_id/images/:image_id/comments/:comment_id/upvote', to:'comments#upvote_comment'
  post '/subreddits/:subreddit_id/images/:image_id/comments/:comment_id/downvote', to:'comments#downvote_comment'
  post '/subreddits/:subreddit_id/images/:image_id/comments/make', to:'comments#make_comment'

  post '/add_subreddit/:user_id/:subreddit_id', to:'registrations#add_subreddit'
  delete '/drop_subreddit/:user_id/:subreddit_id', to:'registrations#drop_subreddit'

  post '/add_follow/:follower_id/:following_id', to:'followships#add_follow'
  delete '/delete_follow/:follower_id/:following_id', to:'followships#delete_follow'

  get '/followships/:user_id', to:'followships#view_followships'
  get '/users/:user_id/followship_feed', to:'users#view_followships_feed'
end
