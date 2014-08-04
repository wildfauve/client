Rails.application.routes.draw do
  
  root :to => "customers#index"
      
  resources :customers
  
  resources :licences
  
  resources :identities, only: [:index] do
    collection do
      get 'sign_up'
      get 'login'
      get 'authorisation'
      put 'logout'
    end
  end
  
  namespace :api do
    namespace :v1 do
      resources :feeds
      resources :customers
    end
  end
end
