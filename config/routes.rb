Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  namespace :api do
    namespace :v1 do
      resources :items
      resources :carts
      resources :cart_items
      post 'users/sign_up', to: 'users#sign_up'
      post 'users/sign_in', to: 'users#sign_in'

      post 'carts/add_to_cart', to: 'carts#add_to_cart' 
    end
  end
end
