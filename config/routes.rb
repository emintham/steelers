Steelers::Application.routes.draw do

  authenticated :user do
     mount Precious::App, at: 'wiki'
     root :to => 'home#index'
     resources :config_templates
     resources :admins
     resources :servers
     resources :programs do
        member do
           post :toggle
           post :change_type
        end
     end
     get "home/job_landing"
     get "home/new_upload"
     get "home/new_oth"
     get "home/new_ls"
     post "home/job_redirect"
  end
  
  devise_for :users
  devise_scope :user do
     root :to => "devise/sessions#new"
  end

  resources :users do
     resources :jobs do
        member { post :run }
     end
     resources :userfiles do
        member { post :import }
     end
     resources :logs
     resources :confs
  end

  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
