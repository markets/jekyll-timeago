require "jekyll/timeago/version"

module Jekyll
  module Timeago

    DAYS_IN = {
      :days => 1,
      :weeks => 7,
      :months => 31,
      :years => 365,
    }

    def timeago(input)
      time_ago_to_now(input)
    end

    private

    def time_ago_to_now(date)
      unless date.is_a?(Date) || date.is_a?(Time)
        raise "Invalid input: #{date.inspect}"
      end

      days_passed = (Date.today - Date.parse(date.to_s)).to_i

      case days_passed.abs
      when 0...7
        time_ago_to_s(days_passed, :days)
      when 7...31
        time_ago_to_s(days_passed, :weeks)
      when 31...365
        time_ago_to_s(days_passed, :months)
      else
        time_ago_to_s(days_passed, :years)
      end
    end

    def time_ago_to_s(days_passed, grouped_by)
      return "today" if days_passed == 0
      return "yesterday" if days_passed == 1
      return "tomorrow" if days_passed == -1

      future = days_passed < 0
      computed_range = days_passed.abs / Jekyll::Timeago::DAYS_IN[grouped_by]
      grouped_by = if computed_range == 1
        singularize(grouped_by)
      else
        grouped_by.to_s
      end

      if future
        "in #{computed_range} #{grouped_by}"
      else
        "#{computed_range} #{grouped_by} ago"
      end
    end

    def singularize(word)
      word.to_s[0...-1]
    end
  end
end

Liquid::Template.register_filter(Jekyll::Timeago)
