Spree::Core::Engine.add_routes do
 namespace :api do
    namespace :v2 do
      namespace :storefront do
        resources :products, only: [] do
          resources :videos, only: [:index, :create, :update, :destroy]
        end
      end
    end
  end
end
