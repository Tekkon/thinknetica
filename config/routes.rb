Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  devise_scope :user do
    get 'logout', to: 'devise/sessions#destroy'
  end

  resources :questions do
  	resources :answers
  end
end
