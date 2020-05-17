Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'
  resources :projects do 
    resources :bugs, except: [:index, :show]
    resources :team_memberships, only: [:new, :create, :destroy]
  end
  
  patch "bug/:id", to: "bugs#update_solved_status", as: "update_bug_solved_status"
  
  resources :comments, only: [:create]
  
  get "become_user/:id", to: "application#become_user", as: "become_user"
end
