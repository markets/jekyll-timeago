RSpec.describe MiniI18n do
  describe 'load_translations' do
    it "allows to load multiple locales and translations from different files" do
      expect(MiniI18n.available_locales).to eq ["en", "es", "fr"]
      expect(MiniI18n.translations.size). to eq 3
      expect(MiniI18n.translations["en"]).to include 'bye'
    end

    it "allows to load translations from JSON" do
      expect(MiniI18n.t(:from_json)).to eq 'from JSON'
    end

    it "does not raise if path is nil" do
      expect(MiniI18n.load_translations(nil)).to eq []
    end
  end

  describe 'default_locale=' do
    it 'defaults to default_locale if locale is not valid' do
      MiniI18n.default_locale = :foo

      expect(MiniI18n.default_locale).to eq :en
    end
  end

  describe 'available_locales=' do
    it 'wraps into an array of strings' do
      MiniI18n.available_locales = :en

      expect(MiniI18n.available_locales).to eq ["en"]
    end
  end

  describe 'locale' do
    it 'allows to change locale globally' do
      MiniI18n.locale = :en
      expect(MiniI18n.t(:hello)).to eq 'hello'

      MiniI18n.locale = :es
      expect(MiniI18n.t(:hello)).to eq 'hola'
    end
  end

  describe 'separator' do
    it 'allows to customize separator for nested keys' do
      MiniI18n.separator = ' '
      expect(MiniI18n.t('second_level hello')).to eq 'hello 2'

      MiniI18n.separator = '/'
      expect(MiniI18n.t('second_level/hello')).to eq 'hello 2'
    end
  end

  describe 'translate' do
    it "simple key" do
      expect(MiniI18n.t(:hello)).to eq 'hello'
    end

    it "nested key" do
      expect(MiniI18n.t('second_level')).to be_a Hash
      expect(MiniI18n.t('second_level.hello')).to eq 'hello 2'
    end

    it "multiple keys" do
      expect(MiniI18n.t([:hello, :bye])).to eq ['hello', 'bye']
      expect(MiniI18n.t([:hello, :bye], locale: :fr)).to eq ['bonjour', 'au revoir']
    end

    it "locale" do
      expect(MiniI18n.t('hello', locale: :fr)).to eq 'bonjour'
      expect(MiniI18n.t('hello', locale: :es)).to eq 'hola'
    end

    it "multiple locales" do
      expect(MiniI18n.t(:hello, locale: [:en, :fr, :es])).to eq ['hello', 'bonjour', 'hola']
      expect(MiniI18n.t(:hello_interpolation, name: 'world', locale: [:en])).to eq ['hello world']
    end

    it "scope" do
      expect(MiniI18n.t('hello', scope: :second_level)).to eq 'hello 2'
    end

    it "returns nil if key does not exist" do
      expect(MiniI18n.t('foo')).to eq nil
    end

    it "returns default if key does not exist" do
      expect(MiniI18n.t('foo', default: 'bar')).to eq 'bar'
    end

    it "with interpolation" do
      expect(MiniI18n.t('hello_interpolation')).to eq 'hello %{name}'
      expect(MiniI18n.t('hello_interpolation', name: 'world')).to eq 'hello world'
    end

    it "fallbacks" do
      expect(MiniI18n.t('fallback', locale: :es)).to eq ''

      MiniI18n.fallbacks = true
      expect(MiniI18n.t('fallback', locale: :es)).to eq 'fallback'
    end

    it "pluralization" do
      expect(MiniI18n.t('notifications', count: 0)).to eq 'no unread notifications'
      expect(MiniI18n.t('notifications', count: 1)).to eq '1 unread notification'
      expect(MiniI18n.t('notifications', count: 5)).to eq '5 unread notifications'
    end

    it "pluralization with custom rules" do
      MiniI18n.pluralization_rules = {
        es: -> (n) {
          n == 0 ? 'zero' : 'other'
        }
      }

      expect(MiniI18n.t('notifications', count: 0, locale: :es)).to eq 'no hay nuevas notificaciones'
      expect(MiniI18n.t('notifications', count: 1, locale: :es)).to eq 'tienes notificaciones por leer'
    end
  end
end
