Rails.application.routes.draw do
  namespace :api do
   namespace :v1 do
     get '/items/find', to: 'items/find#index'
     get '/merchants/find_all', to: 'merchants/find_all#index'

     resources :merchants, only: [:index, :show] do
       resources :items, module: :merchants, only: [:index]
     end

     resources :items, except: [:new, :edit] do
       resources :merchant, module: :items, only: [:index]
     end

     namespace :revenue do
       resources :merchants, only: [:index, :show]
       resources :items, only: [:index]
       resources :unshipped, only: [:index]
     end
    end
  end
end
