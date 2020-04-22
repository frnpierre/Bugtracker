Rails.application.routes.draw do
  devise_for :users
  root 'static_pages#home'
  resources :projects do 
    resources :bugs, except: [:index, :show]
  end
  
  patch "bug/:id", to: "bugs#update_solved_status", as: "update_bug_solved_status"
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
