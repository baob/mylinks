require 'dotenv'
require 'fileutils'

Dotenv.load

def static_site
  static_site = ENV['STATIC_SITE']
  raise 'STATIC_SITE not defined' if static_site.nil? || static_site == ''
  static_site
end

def static_data
  static_data = ENV['STATIC_DATA']
  raise 'STATIC_DATA not defined' if static_data.nil? || static_data == ''
  static_data
end

def mm_data
  mm_files = ENV['DATA_DIR']
  raise 'DATA_DIR not defined' if mm_files.nil? || mm_files == ''
  mm_files
end

def mm_site
  File.join(app_root, 'build')
end

def app_root
  File.expand_path('../', __FILE__)
end

def copy_dir(source, destination)
  FileUtils.cp_r(File.join(source, '.'), destination)
end

namespace :app do

  desc 'copy built files to static site'
  task :copy_built_files_to_static do
    puts "copying from #{ mm_site } to ..."
    puts "         ... #{ static_site }"
    copy_dir(mm_site, static_site)
  end

  desc 'copy data to static data'
  task :copy_data_to_static do
    puts "copying from #{ mm_data } to ..."
    puts "         ... #{ static_data }"
    copy_dir(mm_data, static_data)
  end

  desc 'copy all to static data'
  task :copy_to_static => [:copy_data_to_static, :copy_built_files_to_static]

end
