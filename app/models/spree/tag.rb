module Spree
  class Tag < ActiveRecord::Base
    belongs_to :product, class_name: 'Spree::Product'

    has_many :video_tags
    has_many :videos, through: :video_tags
  end
end
