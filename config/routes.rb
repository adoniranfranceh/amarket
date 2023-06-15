Rails.application.routes.draw do
  devise_for :admins
  namespace :admintemplate do
    resources :admins
  end

  root 'admin_template/home#index'
end
