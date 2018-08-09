Rails.application.routes.draw do
  resources :ces
  devise_for :users
   root to: "site#home"
end

