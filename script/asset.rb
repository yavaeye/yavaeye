# encoding: UTF-8
require "fileutils"

# coffee -> js and sass -> css compiler
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
    raise "Missing uglifyjs, please run: npm install uglify-js" if `which uglifyjs`.strip.empty?
    raise "Missing sass, please run: bundle install" if `which sass`.strip.empty?
  end

  def compile_js
    in_files = Dir.glob coffee_dir + '/**/*.{js,coffee}'
    out_file = "#{public_dir}/yavaeye.js"
    return if uptodate?(out_file, in_files)
    puts "compiling yavaeye.js"

    data = js_coffee_files_in_order.map do |f|
      f.end_with?('.js') ? (File.binread f) : `coffee -p --bare "#{f}"`
    end
    File.open(out_file, 'w') { |f| f.<< data.join ";\n" }

    if compress
      js = `uglifyjs --no-copyright --no-dead-code < "#{out_file}"`
      File.open(out_file, 'w') { |f| f << js }
    end
  end

  def js_coffee_files_in_order
    yavaeye = "#{coffee_dir}/yavaeye.coffee"
    files = File.readlines(yavaeye).grep(/^#=\s?require\s/)
    files.map! do |f|
      f.sub!(/^#=\s?require\s/, '').strip!
      "#{coffee_dir}/#{f}"
    end
    files << yavaeye
  end

  def compile_css
    in_files = Dir.glob sass_dir + '/**/*.sass'
    out_file = "#{public_dir}/yavaeye.css"
    return if uptodate?(out_file, in_files)
    puts "compress yavaeye.css"

    in_file = "#{sass_dir}/yavaeye.sass"
    env_opt = compress ? '-t compressed' : '-l'
    system %Q[sass --compass #{env_opt} < "#{in_file}" > "#{out_file}"]
  end
end

if __FILE__ == $PROGRAM_NAME # test
  p Asset.new.js_coffee_files_in_order
end