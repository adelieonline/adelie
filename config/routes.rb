Adelie::Application.routes.draw do
  devise_for :users
  root :to => "index#index"
  get 'admin' => 'admin#add_product'
  get 'admin/addproduct' => 'admin#add_product'
  post 'admin/saveproduct' => 'admin#save_product'
  match 'admin/showproduct' => 'admin#show_product', :via => [:get, :post]
  post 'admin/editproduct' => 'admin#edit_product'
  post 'admin/deletepicture' => 'admin#delete_picture'
end
