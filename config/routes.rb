Rails.application.routes.draw do
  devise_for :admins

  namespace :admin_template do
    resources :admins
    resources :customers
    namespace :inventary do
      resources :categories
      resources :products
    end
    resources :products
    resources :inventary
  end

  root 'admin_template/home#index'
end
