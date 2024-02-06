Rails.application.routes.draw do
  get 'rewards/new' => 'rewards#new'
  get 'rewards/edit' => 'rewards#edit'
  get 'rewards/delete' => 'rewards#delete'
  get 'rewards/show' => 'rewards#show'
  get 'rewards/index' => 'rewards#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root 'rewards#index'
  resources :users do
    member do
      get :delete
    end
  end

  resources :rewards do
    member do
      get :delete
    end
  end
end
