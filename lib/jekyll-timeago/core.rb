require 'date'

module Jekyll
  module Timeago
    module Core
      extend self

      DAYS_PER = {
        days:   1,
        weeks:  7,
        months: 30,
        years:  365
      }

      # Max level of detail
      # years > months > weeks > days
      # 1 year and 7 months and 2 weeks and 6 days
      MAX_DEPTH_LEVEL = 4

      # Default level of detail
      # 1 month and 5 days, 3 weeks and 2 days, 2 years and 6 months
      DEFAULT_DEPTH_LEVEL = 2

      def timeago(from, to = Date.today, options = {})
        if to.is_a?(Hash)
          options = to
          to = Date.today
        end

        @options = options

        from  = validate_date(from)
        to    = validate_date(to)
        depth = validate_depth(@options[:depth] || @options["depth"])

        time_ago_to_now(from, to, depth)
      end

      private

      def validate_date(date)
        Date.parse(date.to_s)
      end

      def validate_depth(depth)
        (1..MAX_DEPTH_LEVEL).include?(depth) ? depth : DEFAULT_DEPTH_LEVEL
      end

      def t(key, options = {})
        MiniI18n.translate(key, @options.merge(options))
      end

      # Days passed to time ago sentence
      def time_ago_to_now(from, to, depth)
        days_passed = (to - from).to_i

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
        num_elems  = (days_passed / days).to_i

        current_slots << t(time_range, count: num_elems)

        pending_days = days_passed - (num_elems * days)
        build_time_ago_slots(pending_days, depth - 1, current_slots)
      end

      # Number of days to minimum period time which can be grouped
      def days_to_time_range(days_passed)
        case days_passed.abs
        when 1..6
          :days
        when 7..30
          :weeks
        when 31..365
          :months
        else
          :years
        end
      end

      # Array to sentence: ['1 month', '1 week', '5 days'] => "1 month, 1 week and 5 days"
      def to_sentence(slots)
        if slots.length == 1
          slots[0]
        else
          "#{slots[0...-1].join(t(:words_connector))} #{t(:last_word_connector)} #{slots[-1]}"
        end
      end
    end
  end
end