DepositHarvard::Application.routes.draw do
  resources :deposits
  devise_for :users
  root :to => 'deposits#index'
end
