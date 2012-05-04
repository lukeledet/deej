Deej::Application.routes.draw do
  resources :votes
  resources :songs

  root to: "songs#index"
end
