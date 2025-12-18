Rails.application.routes.draw do
  resources :text_items, only: [:new, :create, :show]  
  root "text_items#new"
end
