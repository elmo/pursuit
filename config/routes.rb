Rails.application.routes.draw do
  resources :pursuit_metrics
  resources :ces
  devise_for :users
   root to: "site#home"
end

