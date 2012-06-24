Whiteboard::Application.routes.draw do
  root to: 'homes#index'
  devise_for :users
end
