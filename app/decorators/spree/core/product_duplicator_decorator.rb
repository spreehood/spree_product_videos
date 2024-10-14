module Spree
  module Core
    module ProductDuplicatorDecorator
      require 'activerecord-import'

      def duplicate
        ActiveRecord::Base.transaction do
          new_product = super
          duplicate_videos(new_product)
          new_product
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Failed to duplicate product: #{e.message}"
        raise
      end

      private

      def duplicate_videos(new_product)
        return if product.videos.empty?
        return if new_product.videos.exists?

        new_videos = build_duplicate_videos(new_product)

        Spree::ProductVideo.import(new_videos, recursive: true, batch_size: 100)

        attach_files_to_videos(new_videos)
      end

      def build_duplicate_videos(new_product)
        product.videos.includes(:tags).map do |video|
          new_video = video.dup
          new_video.product_id = new_product.id
          new_video.tag_ids = video.tag_ids

          # Validate the new video before adding it to the array
          raise ActiveRecord::RecordInvalid.new(new_video) unless new_video.valid?

          new_video
        end
      end

      def attach_files_to_videos(new_videos)
        original_videos = product.videos

        original_videos.each_with_index do |original_video, index|
          new_video = new_videos[index]

          if original_video.file.attached?
            new_video.file.attach(original_video.file.blob)
          end
        end
      end
    end
  end
end

Spree::ProductDuplicator.prepend Spree::Core::ProductDuplicatorDecorator
