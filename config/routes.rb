Rails.application.routes.draw do
  root to: "maps#index"
  get 'about', to: "pages#about"
  get 'admin', to: "pages#admin"

  devise_for :users
  resources :reports
  resources :product_details

  scope '/admin' do
    resources :products
    resources :privileges
    resources :roles
    resources :users, except: [:create, :new]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
