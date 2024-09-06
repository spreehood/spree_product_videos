module Spree
  module ProductVideos
    class Find
      def initialize(scope:, params:)
        @scope = scope
        @tag_name = params.dig(:filter, :tag_name)
      end

      def execute
        filter_by_tag_name
      end

      private

      attr_reader :tag_name, :scope

      def tag_name?
        tag_name.present?
      end

      def filter_by_tag_name
        return @scope unless tag_name?

        tag = Spree::ProductVideoTag.find_by(name: tag_name)

        if tag
          @scope.joins(:tags).where(tags: { id: tag.id })
        else
          @scope.none
        end
      end
    end
  end
end
