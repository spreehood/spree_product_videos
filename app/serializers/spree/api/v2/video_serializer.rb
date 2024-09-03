module Spree
  module Api
    module V2
      class VideoSerializer < BaseSerializer
        attributes :id, :url, :product_id, :created_at

        has_many :tags, serializer: :tag
      end
    end
  end
end
