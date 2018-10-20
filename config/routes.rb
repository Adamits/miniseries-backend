Rails.application.routes.draw do
  namespace :v1 do
    devise_for :users

    resources :authors, only: [:index, :show]

    namespace :account do
      resources :projects do
        resources :compositions, controller: 'projects/compositions', only: [:index, :show, :new, :create, :edit, :update]
      end

      resources :tags
    end

    resources :projects, only: [:index, :show]
    resources :compositions, only: [:index, :show] do
      member do
        post :vote
        post :tag
      end
    end

    resources :tags, only: [:index, :show]
  end
end
