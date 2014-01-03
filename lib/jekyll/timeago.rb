require "jekyll/timeago/version"

module Jekyll
  module Timeago

    DAYS_PER = {
      :days => 1,
      :weeks => 7,
      :months => 30,
      :years => 365
    }

    # Max level of detail
    # years > months > weeks > days
    # 1 year and 7 months and 2 weeks and 6 days
    MAX_DEPTH_LEVEL = 4

    # Default level of detail
    # 1 month and 5 days, 3 weeks and 2 days, 2 years and 6 months
    DEFAULT_DEPTH_LEVEL = 2

    def timeago(input, depth = DEFAULT_DEPTH_LEVEL)
      validate!(input, depth)

      time_ago_to_now(input, depth)
    end

    private

    # Validates inputs
    def validate!(input, depth)
      unless depth_allowed?(depth)
        raise "Invalid depth level: #{depth.inspect}"
      end

      unless input.is_a?(Date) || input.is_a?(Time)
        raise "Invalid input type: #{input.inspect}"
      end
    end

    # Get plugin configuration from site. Returns an empty hash if not provided.
    def config
      @config ||= Jekyll.configuration({}).fetch('jekyll_timeago', {})
    end

    def strings
      {
        :today         => config['day'] || 'today',
        :yesterday     => config['yesterday'] || 'yesterday',
        :tomorrow      => config['tomorrow'] || 'tomorrow',
        :and           => config['and'] ||'and',
        :suffix        => config['suffix'] || 'ago',
        :prefix        => config['prefix'] || '',
        :suffix_future => config['suffix_future'] || '',
        :prefix_future => config['prefix_future'] || 'in',
        :years         => config['years'] || 'years',
        :year          => config['year'] || 'year',
        :months        => config['months'] || 'months',
        :month         => config['month'] || 'month',
        :weeks         => config['weeks'] || 'weeks',
        :week          => config['week'] || 'week',
        :days          => config['days'] || 'days',
        :day           => config['day'] || 'day'
      }
    end

    def translate(key)
      strings[key.to_sym]
    end
    alias_method :t, :translate

    # Days passed to time ago sentence
    def time_ago_to_now(input_date, depth)
      days_passed = (Date.today - Date.parse(input_date.to_s)).to_i

      return t(:today)     if days_passed == 0
      return t(:yesterday) if days_passed == 1
      return t(:tomorrow)  if days_passed == -1

      future   = days_passed < 0
      slots    = build_time_ago_slots(days_passed.abs, depth)
      sentence = to_sentence(slots)

      if future
        "#{t(:prefix_future)} #{sentence} #{t(:suffix_future)}".strip
      else
        "#{t(:prefix)} #{sentence} #{t(:suffix)}".strip
      end
    end

    # Builds time ranges: ['1 month', '5 days']
    # - days_passed: integer in absolute
    # - depth: level of detail
    # - current_slots: built time slots
    def build_time_ago_slots(days_passed, depth, current_slots = [])
      return current_slots if depth == 0 || days_passed == 0

      time_range = days_to_time_range(days_passed)
      days       = DAYS_PER[time_range]
      num_elems  = days_passed / days
      range_type = if num_elems == 1
        t(time_range[0...-1]) # singularize key
      else
        t(time_range)
      end

      current_slots << "#{num_elems} #{range_type}"
      pending_days  = days_passed - (num_elems*days)
      build_time_ago_slots(pending_days, depth - 1, current_slots)
    end

    # Number of days to minimum period time which can be grouped
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

    # Validate if allowed level of detail
    def depth_allowed?(depth)
      (1..MAX_DEPTH_LEVEL).include?(depth)
    end

    # Array to sentence: ['1 month', '1 week', '5 days'] => "1 month, 1 week and 5 days"
    def to_sentence(slots)
      if slots.length == 1
        slots[0]
      else
        "#{slots[0...-1].join(', ')} #{t(:and)} #{slots[-1]}"
      end
    end
  end
end

Liquid::Template.register_filter(Jekyll::Timeago) if defined?(Liquid)
