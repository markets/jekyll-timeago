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

      # Builds time ranges with natural unit conversions: ['1 month', '5 days']
      # Uses mathematical rules to convert units naturally (12 months = 1 year, 4 weeks = 1 month)
      def build_time_ago_slots(days_passed, depth, threshold)
        # Calculate components with natural unit conversions
        components = calculate_natural_components(days_passed)
        
        # Select components based on depth and threshold  
        selected = select_components(components, depth, threshold, days_passed)
        
        # Convert to translated strings
        selected.map { |unit, count| t(unit, count: count) }
      end

      # Calculate time components with natural unit conversions applied
      def calculate_natural_components(days_passed)
        # Calculate raw components using standard division
        years = days_passed / 365
        remaining_days = days_passed % 365
        
        months = remaining_days / 30
        remaining_days = remaining_days % 30
        
        weeks = remaining_days / 7
        days = remaining_days % 7
        
        components = { years: years, months: months, weeks: weeks, days: days }
        
        # Apply natural unit conversions using mathematical rules
        normalize_units(components)
      end

      # Apply mathematical unit conversions (no hardcoded cases)
      def normalize_units(components)
        # Convert 12+ months to years (handles any multiple: 12→1yr, 24→2yr, 36→3yr, etc.)
        if components[:months] >= 12
          additional_years = components[:months] / 12
          components[:years] += additional_years
          components[:months] = components[:months] % 12
        end
        
        # Convert 4+ weeks to months (proportional conversion)
        if components[:weeks] >= 4
          additional_months = components[:weeks] / 4
          components[:months] += additional_months  
          components[:weeks] = components[:weeks] % 4
        end
        
        # After adding months, check again for year conversion (handles cascading)
        if components[:months] >= 12
          additional_years = components[:months] / 12
          components[:years] += additional_years
          components[:months] = components[:months] % 12
        end
        
        components
      end

      # Select components based on depth and apply threshold filtering
      def select_components(components, depth, threshold, total_days)
        # Build array of non-zero components in order of significance
        result = []
        
        [:years, :months, :weeks, :days].each do |unit|
          count = components[unit]
          if count > 0 && result.length < depth
            result << [unit, count]
          end
        end
        
        # Apply threshold filtering to remove insignificant components
        apply_threshold_filtering(result, total_days, threshold)
      end

      # Filter out components that don't meet the threshold
      def apply_threshold_filtering(components, total_days, threshold)
        return components if threshold == 0 || components.length <= 1
        
        # Calculate if smallest component meets threshold
        last_unit, last_count = components.last
        last_unit_days = last_count * days_in(last_unit)
        
        if last_unit_days < (total_days * threshold).floor
          components[0...-1] # Remove last component
        else
          components
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