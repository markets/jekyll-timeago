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

    it 'allows different date formats' do
      expect(timeago('2010-1-1', '2012-1-1')).to eq('2 years ago')
      expect(timeago('2010/1/1', '2012/1/1')).to eq('2 years ago')
      expect(timeago('Jan 2010, 1', 'Jan 2012, 1')).to eq('2 years ago')
      expect(timeago('20100101', '20120101')).to eq('2 years ago')
      expect(timeago('2014-10-06 20:00:00', '2014-10-07 20:00:00')).to eq('yesterday')
    end

    it 'allows to change level of detail' do
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 1)).to eq('1 year ago')
      expect(timeago(sample_date.prev_day(500), sample_date, "depth" => 1)).to eq('1 year ago')
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 2)).to eq('1 year and 4 months ago')
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 3)).to eq('1 year, 4 months and 2 weeks ago')
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 4)).to eq('1 year, 4 months, 2 weeks and 1 day ago')
      expect(timeago(sample_date.prev_day(500), sample_date, depth: 5)).to eq('1 year and 4 months ago')
    end

    it 'allows threshold configuration' do
      expect(timeago(sample_date.prev_day(366), sample_date, threshold: 0.1)).to eq('1 year ago')
      expect(timeago(sample_date.prev_day(366), sample_date, threshold: 0.1, style: :hash)).to eq({years: 1})
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

    it 'allows localization' do
      expect(timeago(sample_date.prev_day(100), sample_date, locale: :fr)).to eq('il y a environ 3 mois et 1 semaine')
      expect(timeago(sample_date.prev_day(100), sample_date, locale: :ru)).to eq('3 месяца и неделю назад')
    end

    it 'allows short style formatting' do
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

    it 'allows short style with different locales' do
      expect(timeago(sample_date.prev_day(365), sample_date, locale: :fr, style: :short)).to eq('il y a environ 1a')
      expect(timeago(sample_date.prev_day(365), sample_date, locale: :ru, style: :short)).to eq('1г назад')
      expect(timeago(sample_date.prev_day(365), sample_date, locale: :es, style: :short)).to eq('hace 1a')
      expect(timeago(sample_date.prev_day(30), sample_date, locale: :de, style: :short)).to eq('vor 1mo')
    end

    it 'allows complex combinations with short style' do
      expect(timeago(sample_date.prev_day(400), sample_date, style: :short)).to eq('1y and 1mo ago')
      expect(timeago(sample_date.prev_day(100), sample_date, style: :short, depth: 1)).to eq('3mo ago')
      expect(timeago(sample_date.prev_day(100), sample_date, style: :short, depth: 3)).to eq('3mo, 1w and 3d ago')
    end

    it 'allows array style formatting' do
      expect(timeago(sample_date.prev_day(365), sample_date, style: :array)).to eq(['1 year'])
      expect(timeago(sample_date.prev_day(365), sample_date, "style" => "array")).to eq(['1 year'])
      expect(timeago(sample_date.prev_day(160), sample_date, style: :array)).to eq(['5 months', '1 week'])
      expect(timeago(sample_date.prev_day(160), sample_date, style: :array, locale: :es)).to eq(['5 meses', '1 semana'])
    end

    it 'allows hash style formatting' do
      expect(timeago(sample_date.prev_day(365), sample_date, style: :hash)).to eq({years: 1})
      expect(timeago(sample_date.prev_day(365), sample_date, "style" => "hash")).to eq({years: 1})
      expect(timeago(sample_date.prev_day(160), sample_date, style: :hash)).to eq({months: 5, weeks: 1})
      expect(timeago(sample_date.prev_day(500), sample_date, style: :hash)).to eq({years: 1, months: 4})
      expect(timeago(sample_date.prev_day(10), sample_date, style: :hash)).to eq({weeks: 1, days: 3})
    end

    it 'allows hash style with special cases' do
      expect(timeago(sample_date, sample_date, style: :hash)).to eq({days: 0})
      expect(timeago(sample_date.prev_day, sample_date, style: :hash)).to eq({days: 1})
      expect(timeago(sample_date.next_day, sample_date, style: :hash)).to eq({days: 1})
    end

    it 'allows hash style with future times' do
      expect(timeago(sample_date.next_day(7), sample_date, style: :hash)).to eq({weeks: 1})
      expect(timeago(sample_date.next_day(365), sample_date, style: :hash)).to eq({years: 1})
      expect(timeago(sample_date.next_day(1000), sample_date, style: :hash)).to eq({years: 2, months: 9})
    end

    it 'allows hash style with depth control' do
      expect(timeago(sample_date.prev_day(500), sample_date, style: :hash, depth: 1)).to eq({years: 1})
      expect(timeago(sample_date.prev_day(500), sample_date, style: :hash, depth: 2)).to eq({years: 1, months: 4})
      expect(timeago(sample_date.prev_day(500), sample_date, style: :hash, depth: 3)).to eq({years: 1, months: 4, weeks: 2})
      expect(timeago(sample_date.prev_day(500), sample_date, style: :hash, depth: 4)).to eq({years: 1, months: 4, weeks: 2, days: 1})
    end

    it 'allows "only" option to accumulate time into single unit' do
      # Test "only: :days"
      expect(timeago(sample_date.prev_day(7), sample_date, only: :days)).to eq('7 days ago')
      expect(timeago(sample_date.prev_day(7), sample_date, "only" => "days")).to eq('7 days ago')
      expect(timeago(sample_date.prev_day(30), sample_date, only: :days)).to eq('30 days ago')
      
      # Test "only: :weeks"
      expect(timeago(sample_date.prev_day(7), sample_date, only: :weeks)).to eq('1 week ago')
      expect(timeago(sample_date.prev_day(14), sample_date, only: :weeks)).to eq('2 weeks ago')
      expect(timeago(sample_date.prev_day(30), sample_date, only: :weeks)).to eq('4 weeks ago')
      expect(timeago(sample_date.prev_day(365), sample_date, only: :weeks)).to eq('52 weeks ago')
      
      # Test "only: :months"
      expect(timeago(sample_date.prev_day(30), sample_date, only: :months)).to eq('1 month ago')
      expect(timeago(sample_date.prev_day(60), sample_date, only: :months)).to eq('2 months ago')
      expect(timeago(sample_date.prev_day(365), sample_date, only: :months)).to eq('12 months ago')
      
      # Test "only: :years"
      expect(timeago(sample_date.prev_day(365), sample_date, only: :years)).to eq('1 year ago')
      expect(timeago(sample_date.prev_day(730), sample_date, only: :years)).to eq('2 years ago')
      expect(timeago(sample_date.prev_day(1000), sample_date, only: :years)).to eq('3 years ago')
    end

    it 'allows "only" option with different styles' do
      # Test with short style
      expect(timeago(sample_date.prev_day(365), sample_date, only: :weeks, style: :short)).to eq('52w ago')
      expect(timeago(sample_date.prev_day(30), sample_date, only: :months, style: :short)).to eq('1mo ago')
      
      # Test with array style
      expect(timeago(sample_date.prev_day(365), sample_date, only: :weeks, style: :array)).to eq(['52 weeks'])
      expect(timeago(sample_date.prev_day(30), sample_date, only: :months, style: :array)).to eq(['1 month'])
      
      # Test with hash style
      expect(timeago(sample_date.prev_day(365), sample_date, only: :weeks, style: :hash)).to eq({weeks: 52})
      expect(timeago(sample_date.prev_day(30), sample_date, only: :months, style: :hash)).to eq({months: 1})
      expect(timeago(sample_date.prev_day(365), sample_date, only: :days, style: :hash)).to eq({days: 365})
      expect(timeago(sample_date.prev_day(365), sample_date, only: :years, style: :hash)).to eq({years: 1})
    end

    it 'allows "only" option with different locales' do
      expect(timeago(sample_date.prev_day(30), sample_date, only: :weeks, locale: :es)).to eq('hace 4 semanas')
      expect(timeago(sample_date.prev_day(365), sample_date, only: :months, locale: :fr)).to eq('il y a environ 12 mois')
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
      expect(`bin/timeago 2016-1-1 2018-1-1 -l fr -s short`).to match("il y a environ 2a")
      expect(`bin/timeago 2016-1-1 2018-1-1 --locale ru --style short`).to match("2г и 1д назад")
    end

    it 'with hash style' do
      expect(`bin/timeago 2016-1-1 2018-1-1 --style hash`).to match("{:years=>2, :days=>1}")
      expect(`bin/timeago 2016-1-1 2018-1-1 -s hash`).to match("{:years=>2, :days=>1}")
      expect(`bin/timeago 2016-1-1 2016-2-1 --style hash`).to match("{:months=>1, :days=>1}")
    end

    it 'with only option' do
      expect(`bin/timeago 2016-1-1 2018-1-1 --only weeks`).to match("104 weeks ago")
      expect(`bin/timeago 2016-1-1 2018-1-1 -o months`).to match("24 months ago")
      expect(`bin/timeago 2016-1-1 2016-2-1 --only days`).to match("31 days ago")
      expect(`bin/timeago 2016-1-1 2018-1-1 -l fr --only months`).to match("il y a environ 24 mois")
      expect(`bin/timeago 2016-1-1 2018-1-1 --only weeks -s short`).to match("104w ago")
      expect(`bin/timeago 2016-1-1 2018-1-1 --only weeks --style hash`).to match("{:weeks=>104}")
    end
  end
end
