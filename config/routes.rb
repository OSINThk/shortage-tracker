LOCALE_SEGMENT = Regexp.new(Rails.application.config.i18n.available_locales.join('|').downcase)

Rails.application.routes.draw do
  scope "(:locale)", locale: LOCALE_SEGMENT do
    root to: "maps#index"
    get 'about', to: "pages#about"
    get 'admin', to: "pages#admin"
    get 'results', to: "maps#results"

    devise_for :users
    resources :reports

    scope '/admin' do
      resources :localizations
      resources :products
      resources :privileges
      resources :roles
      resources :supported_locales
      resources :users, except: [:create, :new]
    end
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
