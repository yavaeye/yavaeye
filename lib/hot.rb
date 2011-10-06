module Hot
  extend self

  def value score, time
    time_seed = Time.new(2011,3,28,22,00,16,"+08:00")
    order = Math.log10([score.abs, 1].max)
    sign = score <=> 0
    seconds = (time.to_i - time_seed.to_i + sign * order * 10800)
    order + seconds * 1.0 / 45000
  end
end

