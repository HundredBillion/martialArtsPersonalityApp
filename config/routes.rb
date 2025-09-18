Rails.application.routes.draw do
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  root "quizzes#index"

  # Session-only quiz endpoints (no :id in the URL)
  get  '/quiz/start',    to: 'quizzes#start',   as: :quiz_start
  get  '/quiz/question', to: 'quizzes#question', as: :quiz_question
  post '/quiz/respond',  to: 'quizzes#respond',  as: :quiz_respond
  get  '/quiz/result',   to: 'quizzes#result',   as: :quiz_result
  post '/quiz/reset',    to: 'quizzes#reset',    as: :quiz_reset
end
