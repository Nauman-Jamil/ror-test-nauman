Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Budget management routes
  resources :budgets do
    resources :budget_allocations, only: [:new, :create, :edit, :update, :destroy] do
      resources :impact_metrics, only: [:new, :create, :edit, :update, :destroy]
    end
    resources :budget_phases, only: [:index, :show, :new, :create, :edit, :update, :destroy] do
      resources :budget_votes, only: [:new, :create, :index, :show]
    end
  end
  
  resources :budget_categories
  resources :impact_metrics, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "budgets#index"
end
