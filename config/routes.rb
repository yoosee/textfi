Rails.application.routes.draw do
#  get 'articles/new'
#  match "/articles/:alt_url", to: 'articles#showbyurl', via: get, alt_url: /.+/

  get 'articles/new'
  match '/articles/:alt_url', to: 'articles#showbyurl', via: 'get', alt_url: /.+/

  resources :users
  resources :articles
  resources :sessions, only: [:new, :create, :destroy]
  resources :media

  match '/signup',  to: 'users#new',    via: 'get'
  match '/signin',  to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'

  root 'articles#index'

end

