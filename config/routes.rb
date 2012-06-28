Whiteboard::Application.routes.draw do
  root to: 'homes#index'
  devise_for :users
  resources :customers, only: %w[new create]
end
