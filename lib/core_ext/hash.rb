# encoding: UTF-8

class Hash
  BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                       autoplay controls loop selected hidden scoped async
                       defer reversed ismap seemless muted required
                       autofocus novalidate formnovalidate open].to_set
  BOOLEAN_ATTRIBUTES.merge(BOOLEAN_ATTRIBUTES.map &:to_sym)
  MATCHER = /
    (?<!\\)
    ((?:\\\\)*)\\
    (?:
      u(\h{4}) | x(\h{2})
    )
  /x
  REPLACER = '\1&#x\2\3;'

  def to_attrs
    r = []
    each_pair do |key, value|
      if BOOLEAN_ATTRIBUTES.include?(key)
        r << %(#{key}="#{key}") if value
      elsif !value.nil?
        case value
        when String
        when Array, Hash
          value = value.to_json
        else
          value = value.to_s
        end
        value = value.inspect
        value.gsub! MATCHER, REPLACER
        r << "#{key}=#{value}"
      end
    end
    r.sort!
    r * ' '
  end
end
