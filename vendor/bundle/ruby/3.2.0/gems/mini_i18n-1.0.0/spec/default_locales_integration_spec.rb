RSpec.describe "Default Locales Integration" do
  let(:date) { Date.new(2023, 12, 25) }
  let(:time) { Time.new(2023, 12, 25, 14, 30) }
  let(:number) { 1234.56 }

  before(:each) do
    @original_translations = MiniI18n.translations.dup
    @original_available_locales = MiniI18n.available_locales.dup
    MiniI18n.available_locales = [:en, :es, :fr, :de, :pt, :it, :nl, :zh, :ja]
  end

  after(:each) do
    MiniI18n.translations.clear
    MiniI18n.translations.merge!(@original_translations)
    MiniI18n.available_locales = @original_available_locales
  end

  describe "Date localization" do
    it "formats dates according to each locale" do
      expect(MiniI18n.l(date, locale: :en)).to eq("Monday 25, December, 2023")
      expect(MiniI18n.l(date, locale: :es)).to eq("25/12/2023")
      expect(MiniI18n.l(date, locale: :fr)).to eq("lundi 25 décembre 2023")
      expect(MiniI18n.l(date, locale: :de)).to eq("Montag, 25. Dezember 2023")
      expect(MiniI18n.l(date, locale: :pt)).to eq("segunda-feira, 25 de dezembro de 2023")
      expect(MiniI18n.l(date, locale: :it)).to eq("lunedì 25 dicembre 2023")
      expect(MiniI18n.l(date, locale: :nl)).to eq("maandag 25 december 2023")
      expect(MiniI18n.l(date, locale: :zh)).to eq("2023年12月25日")
      expect(MiniI18n.l(date, locale: :ja)).to eq("2023年12月25日(月)")
    end

    it "formats short dates according to each locale" do
      expect(MiniI18n.l(date, format: :short, locale: :en)).to eq("25 Dec 23")
      expect(MiniI18n.l(date, format: :short, locale: :es)).to eq("25 dic 23")
      expect(MiniI18n.l(date, format: :short, locale: :fr)).to eq("25 déc 23")
      expect(MiniI18n.l(date, format: :short, locale: :de)).to eq("25.12.23")
      expect(MiniI18n.l(date, format: :short, locale: :pt)).to eq("25/12/23")
      expect(MiniI18n.l(date, format: :short, locale: :it)).to eq("25/12/23")
      expect(MiniI18n.l(date, format: :short, locale: :nl)).to eq("25-12-23")
      expect(MiniI18n.l(date, format: :short, locale: :zh)).to eq("12月25日")
      expect(MiniI18n.l(date, format: :short, locale: :ja)).to eq("12/25")
    end
  end

  describe "Time localization" do
    it "formats times according to each locale" do
      expect(MiniI18n.l(time, locale: :en)).to eq("Mon 25, December, 2023 - 14:30")
      expect(MiniI18n.l(time, locale: :es)).to eq("lun 25 de diciembre de 2023 - 14:30")
      expect(MiniI18n.l(time, locale: :fr)).to eq("lun 25 décembre 2023 - 14:30")
      expect(MiniI18n.l(time, locale: :de)).to eq("Mo, 25. Dezember 2023 - 14:30")
      expect(MiniI18n.l(time, locale: :pt)).to eq("seg, 25 de dezembro de 2023 - 14:30")
      expect(MiniI18n.l(time, locale: :it)).to eq("lun 25 dicembre 2023 - 14:30")
      expect(MiniI18n.l(time, locale: :nl)).to eq("ma 25 december 2023 - 14:30")
      expect(MiniI18n.l(time, locale: :zh)).to eq("2023年12月25日 星期一 14:30")
      expect(MiniI18n.l(time, locale: :ja)).to eq("2023年12月25日(月) 14時30分")
    end
  end

  describe "Number localization" do
    it "formats numbers according to each locale" do
      expect(MiniI18n.l(number, locale: :en)).to eq("1,234.56")
      expect(MiniI18n.l(number, locale: :es)).to eq("1.234,56")
      expect(MiniI18n.l(number, locale: :fr)).to eq("1 234,56")
      expect(MiniI18n.l(number, locale: :de)).to eq("1.234,56")
      expect(MiniI18n.l(number, locale: :pt)).to eq("1.234,56")
      expect(MiniI18n.l(number, locale: :it)).to eq("1.234,56")
      expect(MiniI18n.l(number, locale: :nl)).to eq("1.234,56")
      expect(MiniI18n.l(number, locale: :zh)).to eq("1,234.56")
      expect(MiniI18n.l(number, locale: :ja)).to eq("1,234.56")
    end
  end
end
