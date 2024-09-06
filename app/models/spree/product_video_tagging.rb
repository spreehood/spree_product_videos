module Spree
  class ProductVideoTagging < ActiveRecord::Base
    belongs_to :product_video, class_name: 'Spree::ProductVideo'
    belongs_to :product_video_tag, class_name: 'Spree::ProductVideoTag'
  end
end
