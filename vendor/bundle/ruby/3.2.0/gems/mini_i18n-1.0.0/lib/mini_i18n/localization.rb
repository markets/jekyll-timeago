require 'time'

module MiniI18n
  module Localization
    extend self

    DELIMITER_REGEX = /\d(?=(\d{3})+(?!\d))/
    DAYS_MONTHS_REGEX = /%[aAbB]/

    def localize(object, options = {})
      case object
      when Numeric
        localize_number(object, options)
      when Date
        localize_datetime(object, options.merge(type: :date))
      when Time, DateTime
        localize_datetime(object, options.merge(type: :time))
      when String
        localize_string(object, options)
      end
    end
    alias l localize

    private

    def localize_number(number, options)
      locale = options[:locale]
      delimiter = MiniI18n.t("number.format.delimiter", locale: locale)
      separator = MiniI18n.t("number.format.separator", locale: locale)
      integer, fractional = number.to_s.split('.')

      integer.to_s.gsub!(DELIMITER_REGEX) do |match|
        "#{match}#{delimiter}"
      end

      number = [integer, fractional].compact.join(separator)

      if as = options[:as]
        number = MiniI18n.t("number.as.#{as}", number: number, locale: locale)
      end

      number
    end

    def localize_datetime(object, options)
      locale = options[:locale]
      type = options[:type]
      format = MiniI18n.t("#{type}.formats.#{options[:format] || 'default'}", locale: locale)

      format.gsub!(DAYS_MONTHS_REGEX) do |match|
        {
          '%a' => MiniI18n.t('date.abbr_day_names', locale: locale)[object.wday],
          '%A' => MiniI18n.t('date.day_names', locale: locale)[object.wday],
          '%b' => MiniI18n.t('date.abbr_month_names', locale: locale)[object.month - 1],
          '%B' => MiniI18n.t('date.month_names', locale: locale)[object.month - 1]
        }[match]
      end

      object.strftime(format)
    end

    def localize_string(string, options)
      object = if options[:type] == :number || options[:as]
        string.to_f
      elsif options[:type] == :date
        Date.parse(string) rescue nil
      else
        Time.parse(string) rescue nil
      end

      object && localize(object, options)
    end
  end
end