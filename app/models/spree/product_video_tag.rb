module Spree
  class ProductVideoTag < ActiveRecord::Base
    belongs_to :product, class_name: 'Spree::Product'

    has_many :product_video_taggings, class_name: 'Spree::ProductVideoTagging'
    has_many :videos, through: :product_video_taggings, source: :product_video
  end
end
