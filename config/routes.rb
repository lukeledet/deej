Deej::Application.routes.draw do
  resources :songs do
    get :queue, on: :collection
    get :download, on: :member
    resources :votes
  end

  root to: "songs#index"
end
