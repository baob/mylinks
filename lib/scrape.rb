require 'nokogiri'
require 'fileutils'
require_relative 'scrape/cell'

class Scrape

  attr_reader :dir

  def initialize(opts = {})
    @dir = opts[:dir] || 'you_forgot_to_specify_dir'
  end

  def run
    old_dir_glob.each do |file|
      page_name = File.basename(file).split('.').first
      page = Nokogiri::HTML(File.open(file))
      output_dir = File.join(app_root, dir, page_name)

      FileUtils.mkdir_p(output_dir)

      page.css('body > table > tr > td').each do |cell|
        Cell.new(cell: cell, output_dir: output_dir).parse
      end
    end
  end

  def clear
    Dir[File.join(app_root, dir, '*')].each { |f| FileUtils.rm_rf(f) }
  end

  private

  def app_root
    app_root = File.expand_path('../..', __FILE__)
  end

  def old_dir_glob
    Dir[old_dir]
  end

  def old_dir
    File.join(app_root, '..', '..', 'Sites', 'mylinks', '*.htm')
  end

end
