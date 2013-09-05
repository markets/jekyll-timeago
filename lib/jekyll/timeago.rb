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
      unless input.is_a?(Date) || input.is_a?(Time)
        raise "Invalid input type: #{input.inspect}"
      end

      days_passed = (Date.today - Date.parse(input.to_s)).to_i
      time_ago_to_now(days_passed)
    end

    private

    def time_ago_to_now(days_passed)
      return "today"     if days_passed == 0
      return "yesterday" if days_passed == 1
      return "tomorrow"  if days_passed == -1

      future     = days_passed < 0
      slots      = build_time_ago_slots(days_passed)

      if future
        "in #{slots.join(' and ')}"
      else
        "#{slots.join(' and ')} ago"
      end
    end

    # Builds time ranges: ['1 month', '5 days']
    def build_time_ago_slots(days_passed, depth = true)
      return if days_passed == 0

      time_range = days_to_time_range(days_passed)
      days       = days_in(time_range)
      num_elems  = days_passed.abs / days
      range_type = if num_elems == 1
        time_range.to_s[0...-1] # singularize
      else
        time_range.to_s
      end

      [].tap do |slots|
        slots << "#{num_elems} #{range_type}" # '1 month', '5 days'
        if depth
          pending_days = days_passed - (num_elems*days)
          depth_slots  = build_time_ago_slots(pending_days, false)
          slots << depth_slots if depth_slots.any?
        end
      end
    end

    def days_to_time_range(days_passed)
      case days_passed.abs
      when 0...7
        :days
      when 7...31
        :weeks
      when 31...365
        :months
      else
        :years
      end
    end

    def days_in(time_range)
      Jekyll::Timeago::DAYS_IN[time_range]
    end
  end
end

Liquid::Template.register_filter(Jekyll::Timeago)
