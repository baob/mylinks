class Scrape

  attr_reader :dir

  def initialize(opts = {})
    @dir = opts[:dir] || 'you_forgot_to_specify_dir'
  end

  def run

  end

  def clear
    Dir[File.join(app_root, dir, '*')].each { |f| FileUtils.rm(f) }
  end

  private

  def app_root
    app_root = File.expand_path('../..', __FILE__)
  end

end
