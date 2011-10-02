# encoding: UTF-8
require "fileutils"

class Asset < Struct.new(:compress, :coffee_dir, :sass_dir, :public_dir)
  include FileUtils

  def initialize compress=false
    check
    self.compress = compress
    dir = File.expand_path File.dirname(__FILE__) + '/..'
    self.coffee_dir = dir + '/coffee'
    self.sass_dir = dir + '/sass'
    self.public_dir = dir + '/public'
  end

  def compile
    compile_js
    compile_css
  end

  def check
    raise "Missing coffee-script, please run: npm install coffee-script" if `which coffee`.strip.empty?
    raise "Missing uglifyjs, please run: npm install uglifyjs" if `which uglifyjs`.strip.empty?
    raise "Missing sass, please run: bundle install" if `which sass`.strip.empty?
  end

  def compile_js
    js_files = Dir.glob coffee_dir + '/**/*.js'
    coffee_files = Dir.glob coffee_dir + '/**/*.coffee'
    out_file = "#{public_dir}/yavaeye.js"
    return if uptodate?(out_file, js_files + coffee_files)

    js = ''
    js_files.each do |f|
      js << File.binread(f) << ";\n"
    end
    coffee_files.each do |f|
      js << `coffee -p --bare "#{coffee_dir}/yavaeye.coffee"` << ";\n"
    end
    File.open(out_file, 'w') { |f| f << js }

    if compress
      js = `uglifyjs --no-copyright --no-dead-code < "#{out_file}"`
      File.open(out_file, 'w') { |f| f << js }
    end
  end

  def compile_css
    in_file = "#{sass_dir}/yavaeye.sass"
    out_file = "#{public_dir}/yavaeye.css"
    return if uptodate?(out_file, [in_file])

    system %Q[sass --compass #{'--style compressed' if compress} < "#{in_file}" > "#{out_file}"]
  end
end
