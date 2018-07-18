module Jekyll
  module Timeago
    def self.jekyll_config(context)
      @@jekyll_config ||= context.registers[:site].config.fetch('jekyll_timeago', {})
    end

    def self.page_config(context)
      context['page']
    end

    def self.configure_from_jekyll(context)
      config = jekyll_config(context)
      locale = page_config(context)['locale']

      config[:locale] = locale if locale

      MiniI18n.configure do
        available_locales = config['available_locales']
        default_locale = config['default_locale']
        fallbacks = config['fallbacks']
      end

      config
    end

    module Filter
      def timeago(from, to = Date.today)
        config = Jekyll::Timeago.configure_from_jekyll(@context)

        Core.timeago(from, to, config)
      end
    end

    class Tag < Liquid::Tag
      def initialize(tag_name, dates, tokens)
        super
        @dates = dates.strip.split(' ')
      end

      def render(context)
        config = Jekyll::Timeago.configure_from_jekyll(context)

        from, to = @dates[0], @dates[1]
        to = config if to.nil?
        Core.timeago(from, to, config)
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Timeago::Filter)
Liquid::Template.register_tag('timeago', Jekyll::Timeago::Tag)