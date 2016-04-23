require 'jekyll-timeago/core'
require 'jekyll-timeago/version'

if defined?(Liquid)
  require 'jekyll-timeago/filter'
  require 'jekyll-timeago/tag'

  Liquid::Template.register_filter(Jekyll::Timeago::Filter)
  Liquid::Template.register_tag('timeago', Jekyll::Timeago::Tag)
end