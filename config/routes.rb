Rails.application.routes.draw do
  root "kjv_bible#index"
  resources :kjv_bible, only: :index
end
