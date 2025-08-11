require 'spec_helper'

describe Jekyll::Timeago do
  context 'Jekyll integration' do
    let(:overrides) do
      {
        "source"      => source_dir,
        "destination" => dest_dir,
        "url"         => "http://example.org",
      }
    end
    let(:config)   { Jekyll.configuration(overrides) }
    let(:site)     { Jekyll::Site.new(config) }
    let(:contents) { File.read(dest_dir("index.html")) }

    it 'setup from Jekyll configuration' do
      expect(site.config['jekyll_timeago']).to eq(configuration_file['jekyll_timeago'])
    end

    it 'process successfully the site using filters and tags' do
      allow(Date).to receive(:today) { Date.new(2016, 1, 1) }
      expect { site.process }.to_not raise_error

      expected =
        "<p>2 años</p>\n"\
        "<p>1 año</p>\n"\
        "<p>1 año</p>\n"\
        "<p>2 años</p>\n"\
        "<p>en 1 año</p>\n"

      expect(contents).to eq(expected)
    end
  end

  context 'Core' do
    let (:sample_date) { Date.new(2014, 7, 30) }
    let (:today) { Date.today }

    before(:all) do
      # Reset original translations
      MiniI18n.configure { |config| config.load_translations(Pathname(__dir__).join("../lib/locales/*.yml")) }
    end

    it 'yesterday, today and tomorrow' do
      expect(timeago(today.prev_day)).to eq("yesterday")
      expect(timeago(today)).to eq("today")
      expect(timeago(today.next_day)).to eq("tomorrow")
    end

    it 'past time' do
      expect(timeago(sample_date.prev_day(10), sample_date)).to eq('1 week and 3 days ago')
      expect(timeago(sample_date.prev_day(100), sample_date)).to eq('3 months and 1 week ago')
      expect(timeago(sample_date.prev_day(500), sample_date)).to eq('1 year and 4 months ago')
    end

    it 'future time' do
      expect(timeago(sample_date.next_day(7), sample_date)).to eq('in 1 week')
      expect(timeago(sample_date.next_day(1000), sample_date)).to eq('in 2 years and 9 months')
      expect(timeago(sample_date.next_day(7), sample_date, locale: :ru)).to eq('через неделю')
      expect(timeago(sample_date.next_day(1000), sample_date, locale: :ru)).to eq('через 2 года и 9 месяцев')
    end

    it 'allow different date formats' do
      expect(timeago('2010-1-1', '2012-1-1')).to eq('2 years ago')
      expect(timeago('2010/1/1', '2012/1/1')).to eq('2 years ago')
      expect(timeago('Jan 2010, 1', 'Jan 2012, 1')).to eq('2 years ago')
      expect(timeago('20100101', '20120101')).to eq('2 years ago')
      expect(timeago('2014-10-06 20:00:00', '2014-10-07 20:00:00')).to eq('yesterday')
    end

    it 'allow to change level of detail' do
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 1)).to eq('1 year ago')
      expect(timeago(sample_date.prev_day(500), sample_date, "depth" => 1)).to eq('1 year ago')
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 2)).to eq('1 year and 4 months ago')
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 3)).to eq('1 year, 4 months and 2 weeks ago')
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 4)).to eq('1 year, 4 months, 2 weeks and 1 day ago')
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 5)).to eq('1 year and 4 months ago')
    end

    it 'allow threshold configuration' do
      expect(timeago(sample_date.prev_day(366), sample_date, threshold: 0.1)).to eq('1 year ago')
    end

    it 'applies rounding rules for natural language' do
      expect(timeago(sample_date.prev_day(58), sample_date)).to eq('2 months ago')
      expect(timeago(sample_date.prev_day(360), sample_date)).to eq('1 year ago')
      expect(timeago(sample_date.prev_day(725), sample_date)).to eq('2 years ago')
      expect(timeago(sample_date.next_day(58), sample_date)).to eq('in 2 months')
      expect(timeago(sample_date.next_day(360), sample_date)).to eq('in 1 year')
      expect(timeago(sample_date.next_day(725), sample_date)).to eq('in 2 years')
      
      # Test cases that should NOT round up
      expect(timeago(sample_date.prev_day(44), sample_date)).to eq('1 month and 2 weeks ago')
      expect(timeago(sample_date.prev_day(545), sample_date)).to eq('1 year and 6 months ago')
    end

    it 'allow localization' do
      expect(timeago(sample_date.prev_day(100), sample_date, locale: :fr)).to eq('il y a environ 3 mois et 1 semaine')
      expect(timeago(sample_date.prev_day(100), sample_date, locale: :ru)).to eq('3 месяца и неделю назад')
    end

    it 'allow short style formatting' do
      expect(timeago(sample_date.prev_day(365), sample_date, style: :short)).to eq('1y ago')
      expect(timeago(sample_date.prev_day(365), sample_date, "style" => "short")).to eq('1y ago')
      expect(timeago(sample_date.prev_day(730), sample_date, style: :short)).to eq('2y ago')
      expect(timeago(sample_date.prev_day(30), sample_date, style: :short)).to eq('1mo ago')
      expect(timeago(sample_date.prev_day(60), sample_date, style: :short)).to eq('2mo ago')
      expect(timeago(sample_date.prev_day(7), sample_date, style: :short)).to eq('1w ago')
      expect(timeago(sample_date.prev_day(14), sample_date, style: :short)).to eq('2w ago')
      expect(timeago(sample_date.prev_day(1), sample_date, style: :short)).to eq('yesterday')
      expect(timeago(sample_date.prev_day(2), sample_date, style: :short)).to eq('2d ago')
    end

    it 'allow short style with different locales' do
      expect(timeago(sample_date.prev_day(365), sample_date, locale: :fr, style: :short)).to eq('il y a environ 1a')
      expect(timeago(sample_date.prev_day(365), sample_date, locale: :ru, style: :short)).to eq('1г назад')
      expect(timeago(sample_date.prev_day(365), sample_date, locale: :es, style: :short)).to eq('hace 1a')
      expect(timeago(sample_date.prev_day(30), sample_date, locale: :de, style: :short)).to eq('vor 1mo')
    end

    it 'allow complex combinations with short style' do
      expect(timeago(sample_date.prev_day(400), sample_date, style: :short)).to eq('1y and 1mo ago')
      expect(timeago(sample_date.prev_day(100), sample_date, style: :short, depth: 1)).to eq('3mo ago')
      expect(timeago(sample_date.prev_day(100), sample_date, style: :short, depth: 3)).to eq('3mo, 1w and 3d ago')
    end

    it 'allow array style formatting' do
      expect(timeago(sample_date.prev_day(365), sample_date, style: :array)).to eq(['1 year'])
      expect(timeago(sample_date.prev_day(365), sample_date, "style" => "array")).to eq(['1 year'])
      expect(timeago(sample_date.prev_day(160), sample_date, style: :array)).to eq(['5 months', '1 week'])
      expect(timeago(sample_date.prev_day(160), sample_date, style: :array, locale: :es)).to eq(['5 meses', '1 semana'])
    end
  end

  context 'CLI' do
    it 'prints help message if called with no params or --help' do
      expect(`bin/timeago`).to match("Usage")
      expect(`bin/timeago --help`).to match("Usage")
    end

    it 'prints current version' do
      expect(`bin/timeago -v`).to match("v#{Jekyll::Timeago::VERSION}")
      expect(`bin/timeago --version`).to match("v#{Jekyll::Timeago::VERSION}")
    end

    it 'computes distance of dates' do
      expect(`bin/timeago 2016-1-1 2016-1-5`).to match("4 days ago")
    end

    it 'prints error with invalid date' do
      expect(`bin/timeago 0`).to match("Error!")
    end

    it 'with custom locale' do
      expect(`bin/timeago 2016-1-1 2016-1-5 -l fr`).to match("il y a environ 4 jours")
      expect(`bin/timeago 2016-1-1 2016-1-5 --locale fr`).to match("il y a environ 4 jours")
      expect(`bin/timeago 2016-1-1 2016-1-5 --locale ru`).to match("4 дня назад")
    end

    it 'with short style' do
      expect(`bin/timeago 2016-1-1 2018-1-1 -s short`).to match("2y and 1d ago")
      expect(`bin/timeago 2016-1-1 2018-1-1 --style short`).to match("2y and 1d ago")
      expect(`bin/timeago 2016-1-1 2016-2-1 -s short`).to match("1mo and 1d ago")
    end

    it 'with combined locale and style options' do
      expect(`bin/timeago 2016-1-1 2018-1-1 -l fr -s short`).to match("il y a environ 2a")
      expect(`bin/timeago 2016-1-1 2018-1-1 --locale ru --style short`).to match("2г и 1д назад")
    end
  end
end
