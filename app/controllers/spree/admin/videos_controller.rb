# frozen_string_literal: true

module Spree
  module Admin
    class VideosController < ResourceController
      belongs_to 'spree/product', find_by: :slug

      def index
        @product = Spree::Product.friendly.find(params[:product_id])
        @collection = @collection.page params[:page]
      end

      def new
        @product = Spree::Product.friendly.find(params[:product_id])
        @video = @product.videos.new
      end

      def edit
        @product = Spree::Product.friendly.find(params[:product_id])
        @video = @product.videos.find(params[:id])
        
        @video.tag_attributes = { name: @video.tags.pluck(:name).join(', ') }
      end

      private

      def model_class
        Spree::ProductVideo
      end

      def collection_url
        admin_product_videos_url(@product)
      end
    end
  end
end
