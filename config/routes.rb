Rails.application.routes.draw do
  
  resources :users
  
  resources :reports do
    collection do
      post :welcome
    end
  end

  root to: 'reports#welcome'
end
