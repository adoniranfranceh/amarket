Rails.application.routes.draw do
  devise_for :admins

  namespace :admin_template do
    resources :admins
    resources :customers
    namespace :inventary do
      resources :products
    end
    resources :categories
    resources :products
    resources :inventary
    resources :sales
  end

  root 'admin_template/home#index'
end
