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
end