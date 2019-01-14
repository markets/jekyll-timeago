require 'mini_i18n'
require_relative 'jekyll-timeago/version'
require_relative 'jekyll-timeago/core'

if defined?(Jekyll) && defined?(Liquid)
  require_relative 'jekyll-timeago/jekyll_integration'
end

module Jekyll
  module Timeago
    extend self

    def timeago(from, to = Date.today, options = {})
      Core.timeago(from, to, options)
    end
  end
end

MiniI18n.configure do |config|
  config.load_translations(__dir__ + '/locales/*.yml')
  config.pluralization_rules = {
    ru: -> (n) {
      r = n % 10
      if n != 11 && r == 1
        'one'
      elsif !(12..14).include?(n) && (2..4).include?(r)
        'few'
      else
        'other'
      end
    }
  }
end
