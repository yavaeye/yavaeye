# encoding: UTF-8

# misc util methods
module YavaUtils
  extend self

  def boot_timestamp
    @boot_timestamp ||= Time.now.to_i
  end

  def hot_value score, time
    time_seed = Time.new(2011,3,28,22,00,16,"+08:00")
    order = Math.log10([score.abs, 1].max)
    sign = score <=> 0
    seconds = (time.to_i - time_seed.to_i)
    sign * order + seconds * 1.0 / 45000
  end

  def load_i18n root
    I18n.locale = :'zh-CN'
    I18n.load_path = I18n.load_path.map do |f|
      f.sub!(/en\.yml$/, 'zh-CN.yml')
      f if File.exist? f
    end.compact
    I18n.load_path.<< root + '/config/zh-CN.yml'
    I18n.reload!
  end
end
