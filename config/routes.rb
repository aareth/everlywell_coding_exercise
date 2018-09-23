Rails.application.routes.draw do

  resources :experts do
    member do
      post 'add_friend'
      get 'find_friend'
    end
  end

  root 'experts#index'
end
