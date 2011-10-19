DepositHarvard::Application.routes.draw do
  resources :deposit_requests
  devise_for :users
  root :to => 'deposit_requests#index'
end
