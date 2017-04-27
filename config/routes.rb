Rails.application.routes.draw do

  root to: 'reports#welcome'

  resources :users do
    collection do
      post 'reset_password'
      get 'get_email'
      get 'get_new_password'
      post 'change_password'
      post 'block'
    end

    member do
      get 'get_report_settings'
      get 'get_report_template'
      post 'report_settings'
      post 'report_template'
      post 'delete_report_settings'
      post 'delete_report_template'
    end
  end

  resources :reports do
    collection do
      post :welcome
    end

    member do
      post :generate_pdf
    end
  end

  resources :sessions do
    collection do
      get 'sign_out'
    end
  end

  resources :companies do
    member do
      post 'delete_logo'
    end
  end

end
