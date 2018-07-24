module Jekyll
  module Timeago
    @@jekyll_initialized = nil

    def self.jekyll_config(context)
      @@jekyll_config ||= context.registers[:site].config['jekyll_timeago'] || {}
    end

    def self.jekyll_page_data(context)
      options = jekyll_config(context)
      locale = context['page']['locale']

      options[:locale] = locale if locale

      if !@@jekyll_initialized
        MiniI18n.configure do |config|
          if options['translations_path']
            path = context.registers[:site].source + options['translations_path']
            config.load_translations(path)
          end

          config.available_locales = options['available_locales']
          config.default_locale = options['default_locale']
          config.fallbacks = options['fallbacks']
        end

        @@jekyll_initialized = true
      end

      options
    end

    module Filter
      def timeago(from, to = Date.today)
        options = Jekyll::Timeago.jekyll_page_data(@context)

        Core.timeago(from, to, options)
      end
    end

    class Tag < Liquid::Tag
      def initialize(tag_name, dates, tokens)
        super
        @dates = dates.strip.split(' ')
      end

      def render(context)
        options = Jekyll::Timeago.jekyll_page_data(context)

        from, to = @dates[0], @dates[1]
        to = options if to.nil?
        Core.timeago(from, to, options)
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Timeago::Filter)
Liquid::Template.register_tag('timeago', Jekyll::Timeago::Tag)