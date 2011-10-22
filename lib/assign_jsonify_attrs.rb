# convert and assign string params into Array / Hash according to meta data
module Mongoid::Document
  def assign_jsonify_attrs attrs
    fields = self.class.fields
    attrs.each do |name, value|
      unless value.is_a?(String)
        self[name] = value
        next
      end
      if value.empty?
        self[name] = nil
        next
      end
      type = fields[name].type
      if type == Array or type == Hash
        begin
          value = JSON.parse(value)
          raise "#{value.inspect} is not a #{type}" if value and !value.is_a?(type)
          self[name] = value
        rescue
          errors.add(name, $!.message)
        end
      else
        self[name] = value
      end
    end
  end
end
