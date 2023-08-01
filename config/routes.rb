Rails.application.routes.draw do
  devise_for :admins

  namespace :admin_template do
    resources :admins
    resources :home
    resources :customers
    resources :inventary
    resources :categories
    resources :products
    resources :secondary_products, only: [:index]
    resources :inventary
    resources :sales
  end

  root 'admin_template/home#index'
  get '/search', to: 'admin_template/products#search'
  get '/datas_from_controller', to: 'admin_template/home#datas_from_controller'
end
