module Jekyll
  module Timeago
    def self.jekyll_config(context)
      @@jekyll_config ||= context.registers[:site].config.fetch('jekyll_timeago', {})
    end

    module Filter
      def timeago(from, to = Date.today)
        config = Jekyll::Timeago.jekyll_config(@context)
        MiniI18n.available_locales = config['available_locales']

        Core.timeago(from, to, config)
      end
    end

    class Tag < Liquid::Tag
      def initialize(tag_name, dates, tokens)
        super
        @dates = dates.strip.split(' ')
      end

      def render(context)
        from, to = @dates[0], @dates[1]

        config = Jekyll::Timeago.jekyll_config(context)
        MiniI18n.available_locales = config['available_locales']

        if to
          Core.timeago(from, to, config)
        else
          Core.timeago(from, config)
        end
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Timeago::Filter)
Liquid::Template.register_tag('timeago', Jekyll::Timeago::Tag)