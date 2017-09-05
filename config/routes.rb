Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  concern :voted do
    member do
      post :vote_for
      post :vote_against
      post :revote
    end
  end

  resources :questions, concerns: [:voted] do
    resources :answers do
      put :mark_favorite, on: :member
    end
  end

  resources :answers, concerns: [:voted], only: [:create_vote, :destroy_vote]
  resources :attachments, only: [:destroy]

  mount ActionCable.server => '/cable'
end
