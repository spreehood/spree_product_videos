module Spree
  module Core
    module ProductDuplicatorDecorator
      def duplicate
        new_product = super

        product.videos.each do |video|
          new_video = video.dup
          new_video.product_id = new_product.id
          new_video.save!

          video.tags.each do |tag|
            video_tag = Spree::ProductVideoTag.find_by(name: tag.name)
            new_video.product_video_taggings.create!(product_video_tag_id: video_tag.id)
          end
        end

        new_product
      end
    end
  end
end

Spree::ProductDuplicator.prepend Spree::Core::ProductDuplicatorDecorator
