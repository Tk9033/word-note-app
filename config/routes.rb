Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
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
        patch :answer
        patch :back
        get :result
        post :retry_wrong
      end
    end
  end
end
