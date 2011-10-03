# only with config/secret.rb it can be complete
module Secret
  def session_secret
    doc['session_secret'] or 'x12#!Dsf9(&aO~)' * 16
  end

  def session_secret= s
    h = doc
    h['session_secret'] = s
    update h
  end

  def admin_password= p
    h = doc
    h['admin_password'] = BCrypt::Password.create(p).to_s
    update h
  end

  def first_time
    !doc['admin_password']
  end

  def validate_admin_password p
    BCrypt::Password.new(doc['admin_password']) == p
  end

  def doc
    if h = Mongoid.database['secret'].find_one
      h
    else
      Mongoid.database['secret'].save({})
      doc
    end
  end

  def update h
    Mongoid.database['secret'].save h
  end

  extend self
end