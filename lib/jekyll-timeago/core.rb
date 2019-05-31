require 'date'

module Jekyll
  module Timeago
    module Core
      extend self

      # Max level of detail: years > months > weeks > days
      MAX_DEPTH_LEVEL = 4

      # Default level of detail
      DEFAULT_DEPTH_LEVEL = 2

      # Default threshold
      DEFAULT_THRESHOLD = 0

      def timeago(from, to = Date.today, options = {})
        if to.is_a?(Hash)
          options = to
          to = Date.today
        end

        @options = options

        from      = validate_date(from)
        to        = validate_date(to)
        depth     = validate_depth(@options[:depth] || @options["depth"])
        threshold = validate_threshold(@options[:threshold] || @options["threshold"])

        time_ago_to_now(from, to, depth, threshold)
      end

      private

      def validate_date(date)
        Date.parse(date.to_s)
      end

      def validate_threshold(threshold)
        (0.0..1.0).include?(threshold) ? threshold : DEFAULT_THRESHOLD
      end

      def validate_depth(depth)
        (1..MAX_DEPTH_LEVEL).include?(depth) ? depth : DEFAULT_DEPTH_LEVEL
      end

      def time_ago_to_now(from, to, depth, threshold)
        days_passed = (to - from).to_i

        return t(:today)     if days_passed == 0
        return t(:yesterday) if days_passed == 1
        return t(:tomorrow)  if days_passed == -1

        past_or_future = from < to ? :past : :future
        slots = build_time_ago_slots(days_passed.abs, depth, threshold)

        t(past_or_future, date_range: to_sentence(slots))
      end

      def t(key, options = {})
        MiniI18n.t(key, @options.merge(options))
      end

      # Builds time ranges: ['1 month', '5 days']
      # - days_passed: integer in absolute
      # - depth: level of detail
      # - threshold: minimum fractional difference to keep for next slot
      # - current_slots: built time slots
      def build_time_ago_slots(days_passed, depth, threshold, current_slots = [])
        return current_slots if depth == 0 || days_passed == 0

        range     = days_to_range(days_passed)
        days      = days_in(range)
        num_elems = (days_passed / days).to_i

        current_slots << t(range, count: num_elems)

        pending_days = days_passed - (num_elems * days)

        if pending_days >= (days_passed * threshold).floor
          build_time_ago_slots(pending_days, depth - 1, threshold, current_slots)
        else
          current_slots
        end
      end

      def days_to_range(days)
        case days.abs
        when 1..6 then :days
        when 7..30 then :weeks
        when 31..365 then :months
        else :years
        end
      end

      def days_in(range)
        case range
        when :days then 1
        when :weeks then 7
        when :months then 30
        when :years then 365
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