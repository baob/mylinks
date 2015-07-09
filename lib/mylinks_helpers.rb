require 'yaml'

module MylinksHelpers

  def yaml_load_files(files_glob)
    full_files_glob = File.join(app_root, files_glob, '*')

    Dir[full_files_glob].inject({}) do |result, file|
      key = File.basename(file).split('.').first.to_sym
      result[key] = YAML.load_file(file)
      result
    end
  end

  def yaml_load_file(file)
    full_file = File.join(app_root, file)
    YAML.load_file(full_file)
  end

  def app_root
    app_root = File.expand_path('../..', __FILE__)
  end

end
