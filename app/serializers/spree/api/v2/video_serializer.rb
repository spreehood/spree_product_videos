module Spree
  module Api
    module V2
      class VideoSerializer < BaseSerializer
        attributes :id, :product_id, :created_at

        attribute :url do |object|
          if object.file.attached?
            Rails.application.routes.url_helpers.rails_blob_url(object.file, only_path: true)
          else
            nil 
          end
        end

        has_many :tags, serializer: :tag
      end
    end
  end
end
