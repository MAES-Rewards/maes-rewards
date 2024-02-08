Rails.application.routes.draw do
  get 'activities/index'
  get 'activities/show'
  get 'activities/new'
  get 'activities/edit'
  get 'activities/delete'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :users do
    member do
      get :delete
    end
  end

  resources :activities do
    member do
      get :delete
    end
  end
end
