module Spree
  class ProductVideo < ActiveRecord::Base
    include Rails.application.routes.url_helpers

    belongs_to :product, class_name: 'Spree::Product'
    has_many :product_video_taggings, class_name: 'Spree::ProductVideoTagging'
    has_many :tags, through: :product_video_taggings, source: :product_video_tag

    has_one_attached :file

    validate :acceptable_video
    after_save :generate_video_url, if: :file_attached_and_url_changed?
    after_save :create_or_find_tag_associations

    accepts_nested_attributes_for :tags, allow_destroy: true

    attr_accessor :tag_attributes

    def tag_attributes=(attributes)
      @tag_attributes = attributes
    end

    private

    def acceptable_video
      return unless file.attached?

      acceptable_types = [
        "video/mp4", 
        "video/mpeg",    
        "video/quicktime",  
        "video/webm",      
        "video/ogg",       
        "video/av1" 
      ]
      unless acceptable_types.include?(file.content_type)
        errors.add(:file, "must be a MP4, MPEG, QuickTime, WebM, Ogg, or AV1 video")
      end
    end

    def generate_video_url
      if file.attached?
        public_url = rails_blob_url(file, only_path: true)

        if url != public_url
          self.update_column(:url, public_url)
        end
      end
    end

    def file_attached_and_url_changed?
      file.attached? && url != rails_blob_url(file, only_path: true)
    end

    def create_or_find_tag_associations
      return unless @tag_attributes.present?

      self.product_video_taggings.destroy_all

      tag_names = @tag_attributes['name'].each

      tag_names.each do |tag_name|
        next if tag_name.empty?

        tag = Spree::ProductVideoTag.find_or_create_by(name: tag_name.downcase)
        self.product_video_taggings.find_or_create_by(product_video_tag_id: tag.id)
      end
    end
  end
end
