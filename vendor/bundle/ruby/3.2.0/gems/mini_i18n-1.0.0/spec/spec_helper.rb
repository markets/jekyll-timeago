require 'simplecov'
SimpleCov.start { add_filter 'spec/' }

require "mini_i18n"

RSpec.configure do |config|
  config.order = :rand
  config.disable_monkey_patching!

  config.before(:suite) do
    MiniI18n.load_translations File.expand_path(__dir__ + '/fixtures/locales/*')
  end

  config.before(:each) do
    MiniI18n.locale = :en
    MiniI18n.separator = '.'
    MiniI18n.fallbacks = false
    MiniI18n.available_locales = [:en, :es, :fr]
  end
end
