module Spree
  module PermittedAttributes
    ATTRIBUTES += %i[video_attributes]
    mattr_reader *ATTRIBUTES

    @@video_attributes = [:tag_name, :product_id, :url, :file]
  end
end
