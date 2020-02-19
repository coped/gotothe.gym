Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login', to: 'auth#create'
      post 'auto_login', to: 'auth#auto_login'
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
