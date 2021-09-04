Rails.application.routes.draw do
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
