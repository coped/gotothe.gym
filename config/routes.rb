Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'login',  to: 'auth#create'
      delete 'logout', to: 'auth#destroy'
      resources :workouts, only: [:show, :create, :update, :destroy]
      resources :users, only: [:show, :create, :update, :destroy]
      resources :exercises, param: :name, only: [:index, :show]
    end
  end
end
