require 'nokogiri'

class Scrape

  attr_reader :dir

  def initialize(opts = {})
    @dir = opts[:dir] || 'you_forgot_to_specify_dir'
  end

  def run
    old_pages_names.each do |page_name|
      FileUtils.mkdir_p(File.join(app_root, dir, page_name))
    end

    old_dir_glob.each do |file|
      page = Nokogiri::HTML(File.open(file))
      page_name = File.basename(file).split('.').first
      # puts "\n\n #{page.class}"
      all_results = []
      result = {}
      page.css('body > table > tr > td').children.each do |child|
        # puts child.name
        if child.name == 'h2'
          accumulate_and_clear(all_results, result)

          file_name = child.text.downcase.gsub(/[^a-z0-9]/, '_').gsub(/(_)+/, '_').gsub(/_$/, '')
          # puts file_name
          result[:filename] = File.join(app_root, dir, page_name, "#{file_name}.yml")
          result[:title] = child.text
        end
      end
      accumulate_and_clear(all_results, result)

      all_results.each do |res|
        if res[:filename] 
          FileUtils.touch(res[:filename])
        end
      end

    end
  end

  def clear
    Dir[File.join(app_root, dir, '*')].each { |f| FileUtils.rm_rf(f) }
  end

  private

  def accumulate_and_clear(all_items, item)
    unless item.keys.size == 0
      all_items << item.dup
      item = {}
    end
  end

  def app_root
    app_root = File.expand_path('../..', __FILE__)
  end

  def old_pages_names
    old_dir_glob.map do |f|
      File.basename(f).split('.').first
    end
  end

  def old_dir_glob
    Dir[old_dir]
  end

  def old_dir
    File.join(app_root, '..', '..', 'Sites', 'mylinks', '*.htm')
  end

end
