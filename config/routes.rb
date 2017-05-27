Rails.application.routes.draw do
  resources :users
  resources :pixels
  
  post   "/login"       => "sessions#create"
  delete "/logout"      => "sessions#destroy"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
