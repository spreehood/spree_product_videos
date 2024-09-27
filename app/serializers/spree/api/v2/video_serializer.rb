module Spree
  module Api
    module V2
      class VideoSerializer < BaseSerializer
        attributes :id, :product_id, :created_at

        attribute :url do |object|
          Rails.application.routes.url_helpers.rails_blob_url(object.file, only_path: true)
        end

        has_many :tags, serializer: :tag
      end
    end
  end
end
