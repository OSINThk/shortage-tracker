Rails.application.routes.draw do
  root to: "maps#index"
  get 'about', to: "pages#about"
  get 'admin', to: "pages#admin"
  get 'results', to: "maps#results"

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  resources :reports

  scope '/admin' do
    resources :products
    resources :privileges
    resources :roles
    resources :users, except: [:create, :new]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
