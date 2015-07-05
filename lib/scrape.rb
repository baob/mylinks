class Scrape

  attr_reader :dir

  def initialize(opts = {})
    @dir = opts[:dir] || 'you_forgot_to_specify_dir'
  end

  def run
    old_pages_names.each do |page_name|
      FileUtils.mkdir_p(File.join(app_root, dir, page_name))
    end
  end

  def clear
    Dir[File.join(app_root, dir, '*')].each { |f| FileUtils.rm_rf(f) }
  end

  private

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
