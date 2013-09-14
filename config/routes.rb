Adelie::Application.routes.draw do
  devise_for :users
  root :to => "index#index"
end
