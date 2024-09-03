module Spree
    class Video < ActiveRecord::Base
        belongs_to :product, class_name: 'Spree::Product'
        has_many :video_tags
        has_many :tags, through: :video_tags
        
        has_one_attached :file

        validate :acceptable_video
        after_save :generate_video_url, if: :file_attached_and_url_changed?

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
            if file.attached? && url != file.url
                self.update(url: file.url)
            end
        end

        def file_attached_and_url_changed?
            file.attached? && url != file.url
        end
    end
end