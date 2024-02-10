Rails.application.routes.draw do
  root to: 'dashboards#show'
  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end

  get 'dashboards/member', to: 'dashboards#member', as: 'member_dashboard'
  get 'dashboards/admin', to: 'dashboards#admin', as: 'admin_dashboard'
  get 'rewards/memberindex', to: 'rewards#memberindex', as: 'memrewards_path'
  get 'rewards/purchase/:id', to: 'rewards#purchase', as: 'purchase_path'
  get 'rewards/membershow/:id', to: 'rewards#membershow', as: 'memshow_path'
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

  resources :activities do
    member do
      get :delete
    end
  end
end
