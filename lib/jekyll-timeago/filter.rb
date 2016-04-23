module Jekyll
  module Timeago
    module Filter
      def timeago(from, to = Date.today)
        config = @context.registers[:site].config.fetch('jekyll_timeago', {})

        Jekyll::Timeago::Core.timeago(from, to, config)
      end
    end
  end
end
