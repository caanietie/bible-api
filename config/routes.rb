Rails.application.routes.draw do
  root "kjv_bible#index"
  resources :kjv_bible, only: :index do
    collection do
      resources :api, only: :index
    end
  end
end
