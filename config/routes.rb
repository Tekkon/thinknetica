Rails.application.routes.draw do
  devise_for :users
  root to: "questions#index"

  resources :questions do
    resources :answers do
      put '/mark-favorite' => 'answers#mark_favorite'
    end
  end
end
