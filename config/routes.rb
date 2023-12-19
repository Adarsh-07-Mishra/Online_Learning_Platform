# config/routes.rb
Rails.application.routes.draw do
  get 'subjects/show'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  root to: 'home#index'
  resources :documents, only: [:index, :new, :create]
  get '/all_documents', to: 'documents#all_documents', as: 'all_documents'
end
