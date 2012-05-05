Deej::Application.routes.draw do
  resources :songs do
    get :queue, on: :collection
    resources :votes
  end

  root to: "songs#index"
end
