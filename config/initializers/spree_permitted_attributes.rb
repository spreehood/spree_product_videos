module Spree
  module PermittedAttributes
    ATTRIBUTES += %i[video_attributes]
    mattr_reader *ATTRIBUTES

    @@video_attributes = [:product_id, :url, :file, :tag_name, tag_names: []]
  end
end
