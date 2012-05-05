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
end
