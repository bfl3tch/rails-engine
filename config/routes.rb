Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, module: :merchants, only: [:index]
      end
      resources :items do
        resources :merchants, only: [:index]
      end
    end
  end
end
