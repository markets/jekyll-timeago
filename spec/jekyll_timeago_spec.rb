require 'spec_helper'

describe Jekyll::Timeago do
  context 'Jekyll integration' do
    let(:site) do
      Jekyll::Site.new(site_configuration)
    end

    it 'setup from Jekyll configuration' do
      expect(site.config['jekyll_timeago']).to eql(configuration_file['jekyll_timeago'])
    end

    it 'process successfully the site using filters and tags' do
      expect { site.process }.to_not raise_error
    end
  end

  context 'Timeago calculations' do
    let (:sample_date) { Date.new(2014, 7, 30) }

    before(:each) do
      Jekyll::Timeago::Filter.reset!
    end

    it 'does not accept invalid depth' do
      options[:depth] = 5

      expect { timeago(today) }.to raise_error
    end

    it 'yesterday, today and tomorrow' do
      today = Date.today

      expect(timeago(today - 1.day)).to eql(options[:yesterday])
      expect(timeago(today)).to eql(options[:today])
      expect(timeago(today + 1.day)).to eql(options[:tomorrow])
    end

    context 'past time' do
      it 'should process distances' do
        expect(timeago(sample_date - 10.days, sample_date)).to eql('1 week and 3 days ago')
        expect(timeago(sample_date - 100.days, sample_date)).to eql('3 months and 1 week ago')
        expect(timeago(sample_date - 500.days, sample_date)).to eql('1 year and 4 months ago')
      end
    end

    context 'future time' do
      it 'should process distances' do
        expect(timeago(sample_date + 7.days, sample_date)).to eql('in 1 week')
        expect(timeago(sample_date + 1000.days, sample_date)).to eql('in 2 years and 9 months')
      end
    end

    it 'allow different date inputs' do
      expect(timeago('2010-1-1', '2012-1-1')).to eql('2 years ago')
      expect(timeago('2010/1/1', '2012/1/1')).to eql('2 years ago')
      expect(timeago('Jan 2010, 1', 'Jan 2012, 1')).to eql('2 years ago')
    end

    it 'allow to change level of detail' do
      options[:depth] = 1
      expect(timeago(sample_date - 500.days, sample_date)).to eql('1 year ago')

      options[:depth] = 3
      expect(timeago(sample_date - 500.days, sample_date)).to eql('1 year, 4 months and 2 weeks ago')

      options[:depth] = 4
      expect(timeago(sample_date - 500.days, sample_date)).to eql('1 year, 4 months, 2 weeks and 1 day ago')
    end

    it 'allow localization' do
      options[:prefix] = 'hace'
      options[:months] = 'meses'
      options[:and]    = 'y'
      options[:week]   = 'semana'
      options[:suffix] = nil

      expect(timeago(sample_date - 100.days, sample_date)).to eql('hace 3 meses y 1 semana')
    end
  end
end