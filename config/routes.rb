SocialApp::Application.routes.draw do
  root :to => 'home#index'
  devise_for :users
  

  match '/auth/:provider/callback' => "services#callback"

  resources :projects, :only => [:create, :destroy, :show] do

    resources :services, :only => [:create, :destroy]
    post '/user/:user_id/post' => "services#post", :as => "home_posts"
    get '/:provider/:id/show' => "services#show", :as => "show_posts"
    get '/imap' => "services#imaps", :as => "all_imap"
    get '/imap/add' => "services#add", :as => "add_imap"
    delete '/:setting_id/destroy' => "services#remove_setting", :as => "remove_imap"
    post '/imap/create' => "services#create_imap", :as => "create_imap"
    get '/check/:setting_id/authenticate' => "services#auth_mail", :as => "auth_mail"
    post '/check/:setting_id/mail' => "services#mail", :as => "check_mail"
    post '/imap/authenticate' => "services#authenticate_imap", :as => "authenticate_imap"
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


  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
