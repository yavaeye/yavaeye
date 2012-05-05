require 'rake/sprocketstask'
require 'coffee-script'
require 'compass'
require 'sass'
require 'sprockets-sass'
require 'sprockets-helpers'
require File.dirname(__FILE__) + '/../../config/assets.rb'

Rake::SprocketsTask.new do |t|
  t.environment = Assets::App
  t.output = "./public"
  t.assets = begin
    img_assets = Dir.glob('app/assets/img/**/*.*')
    css_assets = Dir.glob('app/assets/css/*.{sass,scss,less,css}').map{|f| f.sub /#{File.extname f}$/, '.css'}
    js_assets  = Dir.glob('app/assets/js/*.{coffee,js}').map{|f| f.sub /#{File.extname f}$/, '.js'}
    (img_assets + css_assets + js_assets).select do |f|
      f.sub! 'app/assets/', ''
      ! File.basename(f).start_with?('_')
    end
  end
end

desc "fix sprockets clobber_assets removing the whole public dir"
task :clobber_assets do
  include FileUtils
  cd File.dirname(__FILE__) + '/../..'
  puts `pwd`
  rm_rf 'public/js'
  rm_rf 'public/css'
  rm_rf 'public/img'
end
