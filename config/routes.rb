Rails.application.routes.draw do
  root to: 'dashboards#show'
  devise_for :admins, controllers: { omniauth_callbacks: 'admins/omniauth_callbacks' }
  devise_scope :admin do
    get 'admins/sign_in', to: 'admins/sessions#new', as: :new_admin_session
    get 'admins/sign_out', to: 'admins/sessions#destroy', as: :destroy_admin_session
  end

  get '/set_admin_session', to: 'sessiontest#set_admin_session', as: :set_admin_session

  get 'dashboards/member/:id', to: 'dashboards#member', as: 'member_dashboard'
  get 'dashboards/admin', to: 'dashboards#admin', as: 'admin_dashboard'
  get 'rewards/memberindex/:id', to: 'rewards#memberindex', as: 'memrewards_path'
  get 'rewards/purchase/:id/:user_id', to: 'rewards#purchase', as: 'purchase_path'
  get 'rewards/membershow/:id/:user_id', to: 'rewards#membershow', as: 'memshow_path'
  get 'rewards/handle_purchase/:id/:user_id', to: 'rewards#handle_purchase', as: 'handle_purchase'
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
