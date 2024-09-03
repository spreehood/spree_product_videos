Spree::Core::Engine.add_routes do
 namespace :api do
    namespace :v2 do
      namespace :storefront do
      resources :products, only: [] do
        resources :videos, only: [:create, :destroy] do
          collection do
            get :index # To list videos by tag
          end
          member do
            post :add_tag
            delete :remove_tag
          end
        end
      end
      end
    end
  end
end
