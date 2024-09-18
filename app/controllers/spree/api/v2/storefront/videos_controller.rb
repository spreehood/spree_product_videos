module Spree
  module Api
    module V2
      module Storefront
        class VideosController < ::Spree::Api::V2::ResourceController
          include Spree::Api::V2::CollectionOptionsHelpers

          before_action :load_product, only: [:create, :index]
          before_action :load_video, only: [:destroy, :update]
          before_action :require_spree_current_user, only: [:destroy, :create]

          def create
            @video = @product.videos.new(video_params)

            if params[:video][:file].present? && @video.save
              render_serialized_payload { serialize_resource(@video) }
            else
              render_error_payload(@video.errors)
            end
          end

          def update
            if @video.update(video_params)
              render_serialized_payload { serialize_resource(@video) }
            else
              render_error_payload(@video.errors)
            end
          end

          def destroy
            if @video.destroy
              render_serialized_payload { serialize_resource(@video) }
            else
              render_error_payload(@video.errors)
            end
          end

          def index
            render_serialized_payload { serialize_resource(collection) }
          end

          private

          def load_video
            @video = Spree::ProductVideo.find(params[:id])
          end

          def collection
            @videos = Spree::ProductVideos::Find.new(scope: @product.videos, params: params).execute
            collection_paginator.new(@videos, params).call
          end

          def load_product
            @product = Spree::Product.friendly.find(params[:product_id])
          end

          def video_params
            params.require(:video).permit(permitted_video_attributes)
          end

          def permitted_video_attributes
            permitted_attributes.video_attributes
          end

          def resource_serializer
            Spree::Api::V2::VideoSerializer
          end

          def collection_serializer
            Spree::V2::Storefront::VideoSerializer
          end
        end
      end
    end
  end
end
