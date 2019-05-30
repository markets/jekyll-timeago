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
        "<p>12 meses</p>\n"\
        "<p>12 meses</p>\n"\
        "<p>2 años</p>\n"\
        "<p>en 1 año</p>\n"

      expect(contents).to eq(expected)
    end
  end

  context 'Core' do
    let (:sample_date) { Date.new(2014, 7, 30) }
    let (:today) { Date.today }

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
      expect(timeago(sample_date.prev_day(366), sample_date, threshold: 0.05)).to eq('1 year ago')
    end

    it 'allow localization' do
      expect(timeago(sample_date.prev_day(100), sample_date, locale: :fr)).to eq('il y a environ 3 mois et 1 semaine')
      expect(timeago(sample_date.prev_day(100), sample_date, locale: :ru)).to eq('3 месяца и неделю назад')
    end
  end

  context 'CLI' do
    it 'prints help message if called with no params or --help' do
      expect(`bin/jekyll-timeago`).to match("Usage")
      expect(`bin/jekyll-timeago --help`).to match("Usage")
    end

    it 'prints current version' do
      expect(`bin/jekyll-timeago -v`).to match("v#{Jekyll::Timeago::VERSION}")
      expect(`bin/jekyll-timeago --version`).to match("v#{Jekyll::Timeago::VERSION}")
    end

    it 'computes distance of dates' do
      expect(`bin/jekyll-timeago 2016-1-1 2016-1-5`).to match("4 days ago")
    end

    it 'prints error with invalid date' do
      expect(`bin/jekyll-timeago 0`).to match("Error!")
    end

    it 'with custom locale' do
      expect(`bin/jekyll-timeago 2016-1-1 2016-1-5 -l fr`).to match("il y a environ 4 jours")
      expect(`bin/jekyll-timeago 2016-1-1 2016-1-5 --locale fr`).to match("il y a environ 4 jours")
      expect(`bin/jekyll-timeago 2016-1-1 2016-1-5 --locale ru`).to match("4 дня назад")
    end
  end
end
