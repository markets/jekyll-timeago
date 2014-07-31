require 'fileutils'
require 'active_support/core_ext'
require 'jekyll'
require File.expand_path('lib/jekyll-timeago/filter')

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'

  SOURCE_DIR = File.expand_path('../source', __FILE__)
  DEST_DIR   = File.expand_path('../_site', __FILE__)
  FileUtils.rm_rf(DEST_DIR)
  FileUtils.mkdir_p(DEST_DIR)

  def source_dir(*files)
    File.join(SOURCE_DIR, *files)
  end

  def dest_dir(*files)
    File.join(DEST_DIR, *files)
  end

  def configuration_file
    YAML.load_file(File.join(SOURCE_DIR, '_config.yml'))
  end

  def site_configuration(overrides = {})
    Jekyll.configuration(overrides.merge({
      'source'      => source_dir,
      'destination' => dest_dir
    }))
  end

  def timeago(from, to = Date.today)
    Jekyll::Timeago::Filter.timeago(from, to)
  end

  def options
    @options ||= Jekyll::Timeago::Filter.options
  end
end