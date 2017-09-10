Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }

  root to: "questions#index"

  concern :voted do
    member do
      post :vote_for
      post :vote_against
      post :revote
    end
  end

  concern :commented do
    member do
      post :comment
    end
  end

  resources :questions, concerns: [:voted, :commented] do
    resources :answers do
      put :mark_favorite, on: :member
    end
  end

  resources :answers, concerns: [:voted], only: [:create_vote, :destroy_vote]
  resources :answers, concerns: [:commented], only: [:comment]
  resources :attachments, only: [:destroy]

  match '/users/:id/finish_signup' => 'users#finish_signup', via: [:get, :patch], as: :finish_signup
  post '/users/send_finish_signup_email' => 'users#send_finish_signup_email', as: :send_finish_signup_email

  mount ActionCable.server => '/cable'
end
