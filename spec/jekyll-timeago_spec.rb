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
      expect(site.config['jekyll_timeago']).to eql(configuration_file['jekyll_timeago'])
    end

    it 'process successfully the site using filters and tags' do
      allow(Date).to receive(:today) { Date.new(2016, 1, 1) }
      expect { site.process }.to_not raise_error

      lines = [
        "<p>2 years yeah</p>",
        "<p>12 months yeah</p>",
        "<p>12 months yeah</p>",
        "<p>2 years yeah</p>"
      ]
      expect(contents).to eq(lines.join("\n"))
    end
  end

  context 'Core' do
    let (:sample_date) { Date.new(2014, 7, 30) }
    let (:today) { Date.today }

    before do
      Jekyll::Timeago::Core.configure
    end

    it 'does not accept invalid depth' do
      expect { timeago(today, sample_date, "depth" => 5) }.to raise_error(ArgumentError)
    end

    it 'accepts a hash (options) as a second parameter (implicit "to")' do
      expect(timeago(today, "today" => "during the day")).to eq("during the day")
    end

    it 'yesterday, today and tomorrow' do
      expect(timeago(today.prev_day)).to eql("yesterday")
      expect(timeago(today)).to eql("today")
      expect(timeago(today.next_day)).to eql("tomorrow")
    end

    it 'past time' do
      expect(timeago(sample_date.prev_day(10), sample_date)).to eql('1 week and 3 days ago')
      expect(timeago(sample_date.prev_day(100), sample_date)).to eql('3 months and 1 week ago')
      expect(timeago(sample_date.prev_day(500), sample_date)).to eql('1 year and 4 months ago')
    end

    it 'future time' do
      expect(timeago(sample_date.next_day(7), sample_date)).to eql('in 1 week')
      expect(timeago(sample_date.next_day(1000), sample_date)).to eql('in 2 years and 9 months')
    end

    it 'allow different date formats' do
      expect(timeago('2010-1-1', '2012-1-1')).to eql('2 years ago')
      expect(timeago('2010/1/1', '2012/1/1')).to eql('2 years ago')
      expect(timeago('Jan 2010, 1', 'Jan 2012, 1')).to eql('2 years ago')
      expect(timeago('2014-10-06 20:00:00', '2014-10-07 20:00:00')).to eql('yesterday')
    end

    it 'allow to change defaults at global level' do
      Jekyll::Timeago::Core.configure("year" => nil, "depth" => 1, "suffix" => nil)
      expect(timeago(sample_date.prev_day(500), sample_date)).to eql('1')
    end

    it 'allow to change level of detail' do
      expect(timeago(sample_date.prev_day(500), sample_date, "depth" => 1)).to eql('1 year ago')
      expect(timeago(sample_date.prev_day(500), sample_date, "depth" => 3)).to eql('1 year, 4 months and 2 weeks ago')
      expect(timeago(sample_date.prev_day(500), sample_date, "depth" => 4)).to eql('1 year, 4 months, 2 weeks and 1 day ago')
    end

    it 'allow localization' do
      new_options = {
        "prefix" => 'hace',
        "months" => 'meses',
        "and"    => 'y',
        "week"   => 'semana',
        "suffix" => nil
      }

      expect(timeago(sample_date.prev_day(100), sample_date, new_options)).to eql('hace 3 meses y 1 semana')
    end
  end

  context 'CLI' do
    it 'prints help message if called with no params or --help' do
      expect(`jekyll-timeago`).to match("Usage")
      expect(`jekyll-timeago --help`).to match("Usage")
    end

    it 'computes distance of dates' do
      expect(`jekyll-timeago 2016-1-1 2016-1-5`).to match("4 days ago")
    end
  end
end