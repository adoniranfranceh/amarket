Rails.application.routes.draw do
  devise_for :admins
  namespace :admin_template do
    resources :admins
    resources :customers
  end

  root 'admin_template/home#index'
end
