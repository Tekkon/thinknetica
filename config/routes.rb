Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers do
      put :mark_favorite, on: :member
    end
  end

  resources :attachments, only: [:destroy]
  resources :votes, only: [:create, :destroy]
end
