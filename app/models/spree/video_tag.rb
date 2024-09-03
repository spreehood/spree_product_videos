module Spree
  class VideoTag < ActiveRecord::Base
    belongs_to :video, class_name: 'Spree::Video'
    belongs_to :tag, class_name: 'Spree::Tag'
  end
end
