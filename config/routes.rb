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
