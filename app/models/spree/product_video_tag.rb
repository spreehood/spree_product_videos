module Spree
  class ProductVideoTag < ActiveRecord::Base
    has_many :product_video_taggings, class_name: 'Spree::ProductVideoTagging'
    has_many :videos, through: :product_video_taggings, source: :product_video
  end
end
