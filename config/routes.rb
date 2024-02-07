Rails.application.routes.draw do
  get 'rewards/memberindex', to: 'rewards#memberindex', as: 'members_path'
  get 'rewards/purchase/:id', to: 'rewards#purchase', as: 'purchase_path'
  get 'rewards/handle_purchase/:id', to: 'rewards#handle_purchase', as: 'handle_purchase'
  resources :rewards
  # get 'rewards/new', to: 'rewards#new', as: new_reward_path
  # get 'rewards/edit' => 'rewards#edit'
  # get 'rewards/delete' => 'rewards#delete'
  # get 'rewards/show' => 'rewards#show'
  # get 'rewards/index', to: 'rewards#index'

  # get 'rewards/purchase' => 'rewards#purchase'
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
