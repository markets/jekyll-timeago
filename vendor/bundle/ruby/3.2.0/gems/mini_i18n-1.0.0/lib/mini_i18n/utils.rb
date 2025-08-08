module MiniI18n
  module Utils
    extend self

    def interpolate(string, keys)
      string % keys
    rescue KeyError
      string
    end

    def deep_merge(merge_to, merge_from)
      merged = merge_to.clone

      merge_from.each do |key, value|
        key = key.to_s

        if value.is_a?(Hash) && merged[key].is_a?(Hash)
          merged[key] = deep_merge(merged[key], value)
        else
          merged[key] = value
        end
      end

      merged
    end
  end
end