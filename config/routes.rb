Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers do
      put :mark_favorite, on: :member
    end

    #put 'vote/:value', to: 'questions#vote', as: 'vote', on: :member
  end

  resources :attachments, only: [:destroy]
  resources :votes, only: [:create]
end
