Rails.application.routes.draw do
  resources :reports
  resources :privileges
  resources :roles
  devise_for :users
  root to: "maps#index"
  get 'maps/index'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
