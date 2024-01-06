# frozen_string_literal: true

Rails.application.routes.draw do
  mount ActionCable.server => '/cable'
  get 'links/index'
  get 'links/new'
  get 'links/create'
  get 'subjects/show'

  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }

  root to: 'home#index'

  resources :documents, only: %i[index new create destroy show]
  get '/all_documents', to: 'documents#all_documents', as: 'all_documents'

  resources :links do
    collection do
      get :all_links
    end
  end

  resources :friendships, only: %i[create update destroy]
  resources :messages, only: %i[new create]

  # Custom routes for friend requests
  get '/friend_requests', to: 'users#friend_requests', as: 'friend_requests'
  get '/accept_friend_request/:id', to: 'users#accept_friend_request', as: 'accept_friend_request'
  get '/reject_friend_request/:id', to: 'users#reject_friend_request', as: 'reject_friend_request'
  get 'received_messages', to: 'messages#received_messages', as: 'received_messages'
  # get '/accepted_friends', to: 'users#accepted_friends', as: :accepted_friends

  # Generic resource route for users
  resources :users, only: %i[index show] do
    member do
      get :send_friend_request
      get :friend_requests
      post :accept_friend_request
      delete :reject_friend_request
    end
  end
  resources :messages, only: %i[new create] do
    collection do
      post 'reply'
    end
  end

  get 'users/all_users', to: 'users#all_users', as: 'all_users'
end
