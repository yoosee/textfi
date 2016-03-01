Rails.application.routes.draw do
#  get 'articles/new'
#  match "/articles/:alt_url", to: 'articles#showbyurl', via: get, alt_url: /.+/

  get 'articles/new'
  get 'articles/drafts' # index of status: draft
  match '/articles/:id/edit', to: 'articles#edit', via: 'get', id: /\d+/
  match '/articles/:alt_url', to: 'articles#showbyurl', via: 'get', alt_url: /.+/

  resources :blogs
  resources :users
  resources :articles
  resources :sessions, only: [:new, :create, :destroy]
  resources :media

  match '/rss',     to: 'articles#rss', via: 'get'

  match '/signup',  to: 'users#new',    via: 'get'
  match '/signin',  to: 'sessions#new', via: 'get'
  match '/signout', to: 'sessions#destroy', via: 'delete'

  match '/setup', to: 'setup#new', via: 'get'
  match '/setup', to: 'setup#create', via: 'post'

  root 'articles#index'

end

