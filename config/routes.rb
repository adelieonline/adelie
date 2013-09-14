Adelie::Application.routes.draw do
  devise_for :users
  root :to => "index#index"
  get 'admin' => 'admin#add_game'
  get 'admin/addgame' => 'admin#add_game'
end
