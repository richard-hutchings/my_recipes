Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.
  
  root "pages#home"
  get 'pages/home', to: 'pages#home'
  
end
