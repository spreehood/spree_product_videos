# Add access to reviews/ratings to the product model
module Spree
  module ProductDecorator
    def self.prepended(base)
      base.has_many :videos, class_name: 'Spree::ProductVideo'
      base.has_many :tags, through: :videos
    end

    ::Spree::Product.prepend self if ::Spree::Product.included_modules.exclude?(self)
  end
end
