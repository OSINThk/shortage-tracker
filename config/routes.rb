Rails.application.routes.draw do
  root to: "maps#index"
  get 'about', to: "pages#about"
  get 'admin', to: "pages#admin"
  get 'results', to: "maps#results"

  devise_for :users
  resources :reports

  scope "(:locale)", locale: /en|ja|zh-HK|zh-CN|zh-TW/ do
    resources :users, only: [:new, :show]
  end
    
  scope '/admin' do
    resources :products
    resources :privileges
    resources :roles
    resources :users, except: [:create, :new]
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
