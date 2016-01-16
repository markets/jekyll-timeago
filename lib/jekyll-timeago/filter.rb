module Jekyll
  module Timeago
    module Filter
      def timeago(from, to = Date.today)
        Jekyll::Timeago::Core.timeago(from, to, jekyll_config)
      end

      private

      def jekyll_config
        @jekyll_config ||= Jekyll.configuration().fetch('jekyll_timeago', {}) rescue {}
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Timeago::Filter) if defined?(Liquid)