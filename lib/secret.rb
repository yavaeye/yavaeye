module Secret
  def session_secret
    @session_secret ||= begin
      rand(36 ** 256).to_s(36).rjust 256, '*'
    end
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