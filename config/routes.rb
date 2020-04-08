Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login',  to: 'auth#create'
      delete 'logout', to: 'auth#destroy'
      resources :users, only: [:index, :show, :create, :update, :destroy]
    end
  end
end
