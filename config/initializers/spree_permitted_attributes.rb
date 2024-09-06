module Spree
  module PermittedAttributes
    ATTRIBUTES += %i[video_attributes]
    mattr_reader *ATTRIBUTES

    @@video_attributes = [:product_id, :url, :file, { tag_attributes: [:name] }]
  end
end
