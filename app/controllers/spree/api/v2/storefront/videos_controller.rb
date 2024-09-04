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
            tag_names = params[:video][:tag_names] || []
            errors = []

            tag_names.each do |tag_name|
              tag = Spree::ProductVideoTag.find_or_create_by(name: tag_name, product: @video.product)
              if tag.persisted?
                unless @video.tags.include?(tag)
                  @video.tags << tag
                end
              else
                errors << "Failed to create or find tag: #{tag_name}"
              end
            end

            if errors.empty?
              render_serialized_payload { serialize_resource(@video) }
            else
              render_error_payload(errors.join(', '))
            end
          end

          def remove_tag
            tag_names = params[:video][:tag_names] || [] # Expecting an array of tag names
            errors = []

            tag_names.each do |tag_name|
              tag = @video.tags.find_by(name: tag_name)
              if tag
                unless @video.tags.destroy(tag)
                  errors << "Failed to remove tag: #{tag_name}"
                end
              end
            end

            if errors.empty?
              render_serialized_payload { serialize_resource(@video) }
            else
              render_error_payload(errors.join(', '))
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
