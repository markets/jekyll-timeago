require 'fileutils'
require 'jekyll'
require File.expand_path('lib/jekyll-timeago')

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

  def timeago(from, to = Date.today, options = {})
    Jekyll::Timeago::Core.timeago(from, to, options)
  end
end