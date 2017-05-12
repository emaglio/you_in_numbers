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
      post 'get_report_settings'
      get 'get_report_template'
      get 'report_settings'
      get 'report_template'
      delete 'delete_report_settings'
      delete 'delete_report_template'
      get 'settings'
      # used to manage the single obj that create the template
      get 'edit_obj'
      get 'delete_obj'
      post 'add_obj'
      get 'edit_chart'
      get 'save_obj'
    end
  end

  resources :reports do
    collection do
      post 'welcome'
    end

    member do
      post 'generate_pdf'
      post 'generate_image'
      post 'update_template'
      get 'edit_at'
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
