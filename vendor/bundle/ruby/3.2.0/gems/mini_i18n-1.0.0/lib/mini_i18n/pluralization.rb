module MiniI18n
  module Pluralization
    def self.pluralize(mappings, count, locale = MiniI18n.locale)
      rule = MiniI18n.pluralization_rules.fetch(locale.to_sym, default_rule)
      mappings[rule.call(count)]
    end

    private

    def self.default_rule
      -> (n) {
        case n
        when 0
          'zero'
        when 1
          'one'
        else
          'other'
        end
      }
    end
  end
end