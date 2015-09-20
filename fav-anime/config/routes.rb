Rails.application.routes.draw do
  resources :users
  resources :animes do
    resources :users, only: %i(favorite dislike) do
      member do
        post :favorite
        post :dislike
      end
    end
  end

  root to: 'users#index'
end
