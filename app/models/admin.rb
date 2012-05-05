class Admin
  include Mongoid::Document
  field :password, type: String

  def self.initialized?
    doc = last
    doc and doc.password.present?
  end

  def self.password= p
    doc = last || new
    doc.password = BCrypt::Password.create(p).to_s
    doc.save!
  end

  def self.validate_password p
    doc = last
    doc and BCrypt::Password.new(doc.password) == p
  end

  # values of attrs can be json string
  def self.assign_jsonify_attrs obj, attrs
    fields = obj.class.fields
    attrs.each do |name, value|
      unless value.is_a?(String)
        obj[name] = value
        next
      end
      if value.empty?
        obj[name] = nil
        next
      end
      type = fields[name].type
      if type == Array or type == Hash
        begin
          value = JSON.parse(value)
          raise "#{value.inspect} is not a #{type}" if value and !value.is_a?(type)
          obj[name] = value
        rescue
          obj.errors.add(name, $!.message)
        end
      else
        obj[name] = value
      end
    end
  end
end
