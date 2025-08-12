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

      # Available styles
      STYLES = %w(short array hash)

      # Available "only" options
      ONLY_OPTIONS = %w(years months weeks days)

      def timeago(from, to = Date.today, options = {})
        if to.is_a?(Hash)
          options = to
          to = Date.today
        end

        @options = options

        @from      = validate_date(from)
        @to        = validate_date(to)
        @depth     = validate_depth(@options[:depth] || @options["depth"])
        @style     = validate_style(@options[:style] || @options["style"])
        @threshold = validate_threshold(@options[:threshold] || @options["threshold"])
        @only      = validate_only(@options[:only] || @options["only"])

        time_ago_to_now
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

      def validate_style(style)
        style = style.to_s
        STYLES.include?(style) ? style : nil
      end

      def validate_only(only)
        only = only.to_s
        ONLY_OPTIONS.include?(only) ? only : nil
      end

      def time_ago_to_now
        days_passed = (@to - @from).to_i

        if @style == "hash"
          return { localized_unit_name(:days) => 0 }  if days_passed == 0
          return { localized_unit_name(:days) => 1 }  if days_passed == 1
          return { localized_unit_name(:days) => -1 } if days_passed == -1
        elsif @style == "array"
          return [t(:today)]     if days_passed == 0
          return [t(:yesterday)] if days_passed == 1
          return [t(:tomorrow)]  if days_passed == -1
        else
          return t(:today)     if days_passed == 0
          return t(:yesterday) if days_passed == 1
          return t(:tomorrow)  if days_passed == -1
        end

        past_or_future = @from < @to ? :past : :future
        slots = build_time_ago_slots(days_passed.abs)

        if @style == "array" || @style == "hash"
          slots
        else
          t(past_or_future, date_range: to_sentence(slots))
        end
      end

      def t(key, options = {})
        MiniI18n.t(key, @options.merge(options))
      end

      # Translate a time unit, using short form if style is :short
      def translate_unit(unit, count)
        if @style == "short"
          t("#{unit}_short", count: count)
        else
          t(unit, count: count)
        end
      end

      # Get localized unit name for hash keys (always plural form)
      def localized_unit_name(unit)
        # Extract the unit name from the plural form translation
        translated = t(unit, count: 2)
        # Remove any count prefix (e.g. "2 años" -> "años")
        translated.gsub(/^\d+\s+/, '').to_sym
      end

      # Builds time ranges with natural unit conversions: ['1 month', '5 days'] or {:months => 1, :days => 5}
      def build_time_ago_slots(days_passed)
        # If "only" option is specified, calculate total time in that unit
        return build_only_slots(days_passed) if @only
        
        # Calculate components with natural unit conversions
        components = calculate_natural_components(days_passed)
        
        # Select components based on depth and threshold  
        selected = select_components(components, days_passed)
        
        # Format output based on current style
        if @style == "hash"
          result = {}
          selected.each { |unit, count| result[localized_unit_name(unit)] = count }
          result
        else
          selected.map { |unit, count| translate_unit(unit, count) }
        end
      end

      # Build time slots when "only" option is specified
      def build_only_slots(days_passed)
        unit = @only.to_sym
        count = calculate_total_in_unit(days_passed, unit)
        
        if @style == "hash"
          { localized_unit_name(unit) => count }
        else
          [translate_unit(unit, count)]
        end
      end

      # Calculate total time in specified unit
      def calculate_total_in_unit(days_passed, unit)        
        case unit
        when :days
          days_passed
        when :weeks
          # Ensure minimum of 1 week if days_passed > 0
          return 1 if days_passed > 0 && days_passed < 7
          (days_passed / 7.0).round
        when :months
          # Ensure minimum of 1 month if days_passed > 0
          return 1 if days_passed > 0 && days_passed < 30
          (days_passed / 30.0).round
        when :years
          # Ensure minimum of 1 year if days_passed > 0
          return 1 if days_passed > 0 && days_passed < 365
          (days_passed / 365.0).round
        end
      end

      def calculate_natural_components(days_passed)
        years = days_passed / 365
        remaining_days = days_passed % 365
        
        months = remaining_days / 30
        remaining_days = remaining_days % 30
        
        weeks = remaining_days / 7
        days = remaining_days % 7
        
        normalize_units({ years: years, months: months, weeks: weeks, days: days })
      end

      def normalize_units(components)
        # Convert 12+ months to years (handles any multiple: 12 → 1yr, 24 → 2yr, 36 → 3yr, etc.)
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
      def select_components(components, total_days)
        result = []
        
        [:years, :months, :weeks, :days].each do |unit|
          count = components[unit]
          if count > 0 && result.length < @depth
            result << [unit, count]
          end
        end
        
        apply_threshold_filtering(result, total_days)
      end

      # Filter out components that don't meet the threshold
      def apply_threshold_filtering(components, total_days)
        return components if @threshold == 0 || components.length <= 1
        
        # Calculate if smallest component meets threshold
        last_unit, last_count = components.last
        last_unit_days = last_count * days_in(last_unit)
        
        if last_unit_days < (total_days * @threshold).floor
          components[0...-1] # Remove last component
        else
          components
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
