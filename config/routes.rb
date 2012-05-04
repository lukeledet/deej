Deej::Application.routes.draw do
  resources :songs do
    resources :votes
  end

  root to: "songs#index"
end
