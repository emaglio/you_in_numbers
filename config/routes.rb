Rails.application.routes.draw do

  root to: 'reports#welcome'

  resources :users do
    collection do
      get 'request_reset_password'
      get 'confirm_new_password'
      post 'update_new_password'
      get 'get_email'
      get 'get_new_password'
      post 'change_password'
      post 'block'
    end

    member do
      get 'get_report_settings'
      get 'get_report_template'
      get 'report_settings'
      get 'report_template'
      get 'settings'
      # used to manage the single obj that create the template
      get 'edit_obj'
      get 'delete_obj'
      post 'add_obj'
      get 'edit_chart'
      post 'update_chart'
      get 'edit_table'
      post 'update_table'
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
      post 'update_at'
      get 'edit_vo2max'
      post 'update_vo2max'
    end
  end

  resources :subjects do
    collection do
      post 'get_reports'
    end

    member do
      post 'edit_height_weight'
    end
  end

  resources :sessions do
    collection do
      get 'sign_out'
      get 'github'
    end
  end

  resources :companies do
    member do
      post 'delete_logo'
    end
  end

end
