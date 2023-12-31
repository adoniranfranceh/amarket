Rails.application.routes.draw do
  devise_for :admins

  namespace :admin_template do
    resources :admins
    resources :home
    resources :customers do
      collection do
        get 'search',  to: 'customers#search', as: :search
      end
    end
    resources :inventary
    resources :categories
    resources :products
    resources :secondary_products, only: [:index]
    resources :inventary
     resources :sales do
      member do
        get 'invoice', to: 'sales#show_invoice', format: :pdf
        get 'invoice_html', to: 'sales#show_invoice_html', format: :html
        put 'update_status'
      end
    end
    resources :cash
    resources :cash_registers do
      patch :close, on: :collection
      member do
        get :show_cash_register, to: 'cash_registers#show_cash_register', as: :pdf
      end
    end
    resources :movements
    resources :admins, only: [:edit, :update] do
      get :edit_password, on: :member
      put :update_password, on: :member
    end
  end

  root 'admin_template/home#index'
  get '/search', to: 'admin_template/products#search'
  get '/datas_from_controller', to: 'admin_template/home#datas_from_controller'
  post '/validate_admin_password', to: 'admin_template/sales#validate_admin_password'
end
