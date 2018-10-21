require 'fileutils'
require 'jekyll'
require 'jekyll-timeago'

RSpec.configure do |config|
  config.order = :random
  config.include Jekyll::Timeago

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
end