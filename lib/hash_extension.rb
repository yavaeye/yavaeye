class Hash
  BOOLEAN_ATTRIBUTES = %w[disabled readonly multiple checked autobuffer
                       autoplay controls loop selected hidden scoped async
                       defer reversed ismap seemless muted required
                       autofocus novalidate formnovalidate open].to_set
  BOOLEAN_ATTRIBUTES.merge(BOOLEAN_ATTRIBUTES.map &:to_sym)
  
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
        r << "#{key}=#{value.to_json}"
      end
    end
    r.sort!
    r * ' '
  end
end