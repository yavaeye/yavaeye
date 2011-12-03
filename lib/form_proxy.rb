# encoding: UTF-8

# for form helper
FormProxy = Struct.new :klass, :obj
class FormProxy
  def initialize obj
    self.obj = obj
    self.klass = obj.class.name.downcase
  end

  def text field, opts={}
    opts = normalize field, opts
    %(<input type="text" #{opts.to_attrs}></input>)
  end

  def hidden field, opts={}
    opts = normalize field, opts
    %(<input type="hidden" #{opts.to_attrs}></input>)
  end

  def password field, opts={}
    opts = normalize field, opts
    %(<input type="password" #{opts.to_attrs}></input>)
  end

  def checkbox field, opts={}
    opts = normalize field, opts
    opts[:checked] = opts.delete(:value).present?
    opts[:value] = '1'
    %(<input type="hidden" name="#{opts[:name]}" value="0"></input><input type="checkbox" #{opts.to_attrs}></input>)
  end

  def radio field, opts={}
    opts = normalize field, opts
    opts[:checked] = opts.delete(:value).present?
    opts[:value] = '1'
    %(<input type="hidden" name="#{opts[:name]}" value="0"></input><input type="radio" #{opts.to_attrs}></input>)
  end

  def textarea field, opts={}
    opts = normalize field, opts
    v = ::Temple::Utils.escape_html(opts.delete :value)
    %(<textarea #{opts.to_attrs}>#{v}</textarea>)
  end

  def select field, candidates, opts={}
    opts = normalize field, opts
    selected = opts[:value]
    r = '<select ' << opts.to_attrs << '>'
    candidates.each do |(display, value)|
      display = ::Temple::Utils.escape_html display
      value = ::Temple::Utils.escape_html value
      r << %(<option value="#{value}")
      r << %( selected="selected") if !selected.nil? and value == selected
      r << '>' << display << '</option>'
    end
    r << '</select>'
  end

  def submit text, opts={}
    opts = opts.symbolize_keys
    opts[:class] ||= 'button'
    opts[:value] ||= text
    %(<input type="submit" #{opts.to_attrs}></input>)
  end

  def error field 
    content = obj.errors[field.to_sym].join ','
    content = ::Temple::Utils.escape_html content
    %(<span class="error">#{content}</span>)
  end

  private

  def normalize field, opts
    opts = opts.symbolize_keys
    opts[:name] ||= "#{klass}[#{field}]"
    opts[:id] ||= "#{klass}_#{field}"
    opts[:value] ||= obj.send field
    opts
  end
end
