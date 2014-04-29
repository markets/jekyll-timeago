module Jekyll
  module Timeago
    class Tag < Liquid::Tag
      include Jekyll::Timeago::Filter

      def initialize(tag_name, dates, tokens)
        super
        @dates = dates.strip.split(' ')
      end

      def render(context)
        from, to = @dates[0], @dates[1]

        if to
          timeago(from, to)
        else
          timeago(from)
        end
      end
    end
  end
end

Liquid::Template.register_tag('timeago', Jekyll::Timeago::Tag) if defined?(Liquid)
