module Jekyll
  module Timeago
    class Tag < Liquid::Tag
      def initialize(tag_name, dates, tokens)
        super
        @dates = dates.strip.split(' ')
      end

      def render(context)
        from, to = @dates[0], @dates[1]
        config = context.registers[:site].config.fetch('jekyll_timeago', {})

        if to
          Jekyll::Timeago::Core.timeago(from, to, config)
        else
          Jekyll::Timeago::Core.timeago(from, config)
        end
      end
    end
  end
end
