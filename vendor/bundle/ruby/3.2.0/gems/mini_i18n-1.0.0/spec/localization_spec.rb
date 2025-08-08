RSpec.describe MiniI18n::Localization do
  let(:time) { Time.new(2018, 8, 7, 22, 30) }

  describe 'date' do
    it 'accepts different formats' do
      date = time.to_date
      expect(MiniI18n.l(date)).to eq 'Tuesday 07, August, 2018'
      expect(MiniI18n.l(date, format: :short)).to eq '07 Aug 18'
    end
  end

  describe 'time' do
    it 'accepts different formats' do
      expect(MiniI18n.l(time)).to eq 'Tue 07, August, 2018 - 22:30'
      expect(MiniI18n.l(time, format: :short)).to eq '07 Aug 18 - 22:30'
    end
  end

  describe 'string' do
    it 'accepts and defaults to time' do
      time_string = time.to_s
      expect(MiniI18n.l(time_string)).to eq 'Tue 07, August, 2018 - 22:30'
      expect(MiniI18n.l(time_string, type: :time)).to eq 'Tue 07, August, 2018 - 22:30'
    end

    it 'to date' do
      date_string = time.to_date.to_s
      expect(MiniI18n.l(date_string, type: :date, format: :short)).to eq '07 Aug 18'
    end

    it 'to number' do
      expect(MiniI18n.l("1000000", type: :number)).to eq '1,000,000.0'
      expect(MiniI18n.l("1000000", as: :currency)).to eq '1,000,000.0 $'
    end
  end

  describe 'number' do
    it 'uses defined format' do
      expect(MiniI18n.l(9000)).to eq '9,000'
      expect(MiniI18n.l(9000.50)).to eq '9,000.5'
    end

    it 'as' do
      expect(MiniI18n.l(9000, as: :currency)).to eq '9,000 $'
      expect(MiniI18n.l(9000, as: :currency, locale: :es)).to eq '9.000 €'
      expect(MiniI18n.l(125.5, as: :distance)).to eq 'Distance -> 125.5 miles'
    end
  end
end
