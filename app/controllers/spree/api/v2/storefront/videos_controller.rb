module Spree
  module Api
    module V2
      module Storefront
        class VideosController < ::Spree::Api::V2::ResourceController
          include Spree::Api::V2::CollectionOptionsHelpers
          before_action :load_product, only: [:create, :index]
          before_action :load_video, only: [:add_tag, :remove_tag, :destroy]
          before_action :require_spree_current_user, only: [:add_tag, :remove_tag, :destroy, :create]

          def create
            @video = @product.videos.new(video_params)

            if params[:video][:file].present? && @video.save
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

          def add_tag
            tag = Spree::Tag.find_or_create_by(name: params[:video][:tag_name], product: @video.product)

            unless @video.tags.include?(tag)
              @video.tags << tag
            end

            render_serialized_payload { serialize_resource(@video) }
          end

          def remove_tag
            tag = @video.tags.find_by(name: params[:video][:tag_name])

            if tag && @video.tags.destroy(tag)
              render_serialized_payload { serialize_resource(@video) }
            else
              render_error_payload(@video.errors)
            end
          end

          def index
            if params[:video][:tag_name].present?
              tag = Spree::Tag.find_by(name: params[:video][:tag_name], product: @product)
              @videos = tag ? tag.videos : []
            else
              @videos = @product.videos
            end

            render_serialized_payload { serialize_resource(collection) }
          end

          private

          def load_video
            @video = Spree::Video.find(params[:id])
          end

          def collection
            collection_paginator.new(@videos, params).call
          end

          def load_product
            @product = Spree::Product.find(params[:product_id])
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
