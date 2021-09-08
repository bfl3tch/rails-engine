Rails.application.routes.draw do

  # get '/api/v1/items/find', to: '/api/v1/items/find#index'

  namespace :api do
   namespace :v1 do
     get '/items/find', to: 'items/find#index'
     get '/items/find_all', to: 'items/find#show'
     resources :merchants, only: [:index, :show] do
       resources :items, module: :merchants, only: [:index]
     end
     resources :items, except: [:new, :edit] do
       resources :merchant, module: :items, only: [:index]
     end
     # namespace :items do
     #   resources :find_all, module: :items, only: [:index]
     #   resources :find, module: :items, only: [:index]
     # end
     # namespace :merchants do
     #   resources :find_all, module: :merchants, only: [:index]
     #   resources :find, module: :merchants, only: [:index]
     # end
    end
  end
end
