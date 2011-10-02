module Seg
  extend self

  def segment text
    segments = {}
    mmseg = RMMSeg::Algorithm.new(text)
    while segment = mmseg.next_token
      key = segment.text.force_encoding 'utf-8'
      segments[key] = true
      key.chars do |char|
        segments[char] = true
      end
    end
    segments.keys.map { |k| k.downcase }.uniq
  end
end

