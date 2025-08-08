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
        slots = apply_rounding_rules(slots)

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

      # Apply rounding rules to handle cases like "1 month and 4 weeks" -> "2 months"
      # and "1 year and 12 months" -> "2 years"
      def apply_rounding_rules(slots)
        # Handle single slot case: "12 months" -> "1 year"
        if slots.length == 1
          count, unit = parse_slot_info(slots[0])
          if unit == :months && count == 12
            return [t(:years, count: 1)]
          end
          return slots
        end

        return slots if slots.length < 2

        # Parse the first slot to get unit and count
        first_slot = slots[0]
        second_slot = slots[1]

        # Extract count and unit from localized strings by checking known patterns
        first_count, first_unit = parse_slot_info(first_slot)
        second_count, second_unit = parse_slot_info(second_slot)

        return slots unless first_count && first_unit && second_count && second_unit

        # Apply rounding rules
        if should_round_up?(first_unit, second_unit, second_count)
          # Create rounded up slot
          new_count = first_count + 1
          rounded_slot = t(first_unit, count: new_count)
          [rounded_slot]
        else
          slots
        end
      end

      # Parse slot information to extract count and unit
      def parse_slot_info(slot)
        # This is a simplified approach - we'll extract the unit by checking translations
        units = [:years, :months, :weeks, :days]
        
        units.each do |unit|
          # Generate sample translations to match against
          (1..15).each do |count|
            sample = t(unit, count: count)
            if slot == sample
              return [count, unit]
            end
          end
        end
        
        [nil, nil]
      end

      # Determine if we should round up based on the units and count
      def should_round_up?(first_unit, second_unit, second_count)
        case [first_unit, second_unit]
        when [:months, :weeks]
          second_count == 4  # 4 weeks ≈ 1 month
        when [:years, :months]
          second_count == 12  # 12 months = 1 year
        else
          false
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