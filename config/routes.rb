Whiteboard::Application.routes.draw do
  root to: 'homes#index'
  devise_for :users
  resources :customers, only: %w[new create]
  resources :plans, only: %w[index]
  resources :subscriptions, only: %w[create destroy]
  resources :projects, only: %w[index new create destroy]
end
