Rails.application.routes.draw do
  root "kjv_bible#index"
  resources :kjv_bible, only: :index do
    collection do
      resources :api, only: :index
      namespace :api do
        resources :kjv_bible, only: :show
        get "kjv_bible/search/:id",  to: "search#show"
        get "kjv_bible/:book/:chapter", to: "chapters#show"
        get "kjv_bible/:book/:chapter/verses", to: "verses#index"
        get "kjv_bible/:book/:chapter/:verse", to: "verses#show"
      end
    end
  end
end
