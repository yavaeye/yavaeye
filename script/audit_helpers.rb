# show helpers with the same name

DefinedHelpers = {}
def DefinedHelpers.color s 
  "\e[36m#{s}\e[0m"
end
def DefinedHelpers.add m, f, is_module=false
  f = color f if is_module
  if self[m]
    puts "conflict helper #{color m} in both\n\t#{self[m]}\n\t#{f}"
  else
    self[m] = f
  end
end

Dir.glob(File.dirname(__FILE__) + '/../app/helpers/*.rb') do |f|
  f = File.expand_path f
  `sed -n 's/^  def //p' #{f}`.scan(/^\w+/) do |s|
    DefinedHelpers.add s, f
  end
  `sed -n 's/^  include //p' #{f}`.split("\s").each do |m|
    Module.const_get(m).instance_methods.each do |s|
      DefinedHelpers.add s.to_s, m, true
    end
  end
end
