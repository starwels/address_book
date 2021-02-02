Rails.application.routes.draw do
  root 'health_check#index'

  namespace :api do
    namespace :v1 do
      resources :authentications, only: [:create]
      resources :contacts, only: [:index, :create, :update, :destroy]
      resources :organizations, only: [:index, :create]
      resources :registrations, only: [:create]
    end
  end
end
