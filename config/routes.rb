Adelie::Application.routes.draw do
  devise_for :users
  root :to => "index#index"


  get 'admin' => 'admin#add_product'
  get 'admin/addproduct' => 'admin#add_product'
  post 'admin/saveproduct' => 'admin#save_product'
  match 'admin/showproduct' => 'admin#show_product', :via => [:get, :post]
  post 'admin/editproduct' => 'admin#edit_product'
  post 'admin/deletepicture' => 'admin#delete_picture'
  match 'admin/givecredit/:id' => 'admin#give_credit', :via => [:get, :post]
  post 'admin/savetiers' => 'admin#save_tiers'

  get '/products' => 'index#index'
  get '/how-it-works' => 'index#howitworks'

  get 'cart' => 'cart#show'
  post 'cart/add' => 'cart#add'
  post 'cart/update' => 'cart#update'


  get 'product/:id' => 'product#show'


  get 'checkout' => 'checkout#show'
  post 'checkout/checkout' => 'checkout#checkout'
  get 'checkout/receipt/:id' => 'checkout#receipt'


  get 'account' => 'account#show'
end
