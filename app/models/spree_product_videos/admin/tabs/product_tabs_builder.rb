# frozen string literal: true

module SpreeProductVideos
  module Admin
    module Tabs
      class ProductTabsBuilder
        include ::Spree::Core::Engine.routes.url_helpers

        def build
          add_videos_tab
        end

        private

        def add_videos_tab
          Spree::Admin::Tabs::TabBuilder.new('products_videos.videos', ->(resource) { admin_product_videos_path(resource) }).
            with_icon_key('camera-video.svg').
            with_active_check.
            with_admin_ability_check(::Spree::ProductVideo).
            build
        end
      end
    end
  end
end