require 'nokogiri'
require 'fileutils'
require 'yaml'

class Scrape
  class Bookmarks

    attr_reader :dir, :file, :page_name, :output_dir, :output_file

    def initialize(opts = {})
      @file = opts[:file] || 'old_data/bookmarks.htm'
      @dir = opts[:dir] || 'data'
      @page_name = File.basename(file).split('.').first
      @output_dir = File.join(app_root, dir, page_name)
      @output_file = File.join(output_dir, "#{page_name}.yml")
    end

    def run
      page = Nokogiri::HTML(File.open(file))

      FileUtils.mkdir_p(output_dir)

      result = {}

      page.css('a').each do |bookmark|
        extract_anchor_tag_into(result, bookmark)
      end
      File.open(output_file, 'w') {|f| f.write result.to_yaml }
    end

    def clear
      Dir[File.join(output_dir, '*')].each { |f| FileUtils.rm_rf(f) }
    end

    private

    def app_root
      app_root = File.expand_path('../../..', __FILE__)
    end

    def extract_anchor_tag_into(result, child)
      anchor = { 'anchor' => { 'href' => child.attributes['href'].value.strip, 'text' => child.text.strip } }
      result['elements'] ||= []
      result['elements'] << anchor
    end

  end
end
