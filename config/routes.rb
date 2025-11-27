Rails.application.routes.draw do
  resources :texts, only: [:new, :create, :show]  
  root "texts#new"
end
