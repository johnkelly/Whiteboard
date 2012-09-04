Whiteboard::Application.routes.draw do
  root to: 'homes#index'
  devise_for :users, controllers: { registrations: 'registrations' }
  resources :customers, only: %w[new create]
  resources :plans, only: %w[index]
  resources :subscriptions, only: %w[create destroy]
  resources :whiteboards, only: %w[index create update show]
  resources :pusher, only: %w[] do
    collection { post :auth }
  end
end
