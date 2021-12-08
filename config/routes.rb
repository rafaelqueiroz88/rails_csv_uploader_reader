Rails.application.routes.draw do
  
  root "products#index"
  resources :products
  
  match "/file_upload", to: "products#upload", via: :post

end