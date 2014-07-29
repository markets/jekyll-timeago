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
    # TODO
  end
end