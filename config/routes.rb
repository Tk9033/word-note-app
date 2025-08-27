Rails.application.routes.draw do
  resources :users, only: %i[new create]

  get    "/login",  to: "sessions#new",     as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: :logout


  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # Defines the root path route ("/")
  root "decks#index"

  # root "posts#index"
  resources :decks do
    resources :cards, only: [ :new, :create, :edit, :update, :destroy ]
    # POST /decks/:deck_id/study_sessions
    # GET  /decks/:deck_id/study_sessions/:id
    # ...
    resources :study_sessions, only: [ :create, :show ] do
      member do
        post :answer
        post :back
        get :result
        post :retry_wrong
      end
    end
  end
end
