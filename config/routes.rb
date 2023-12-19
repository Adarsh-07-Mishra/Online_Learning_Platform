# config/routes.rb
Rails.application.routes.draw do
  get 'subjects/show'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root to: 'home#index'
  resources :documents, only: [:index, :new, :create]
end
