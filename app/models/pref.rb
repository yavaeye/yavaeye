# coding: utf-8

# store per-app specific preferences
class Pref < ActiveRecord::Base
  include Hstore

  def self.[] key
    where(key: key).first || create!(key: key)
  end

  def self.initialized?
    self['admin'].value['encrypted_password'].present?
  end

  def self.admin_password= p
    self['admin'].hstore_update! :value, encrypted_password: BCrypt::Password.create(p).to_s
  end

  def self.validate_admin_password p
    enc_p = self['admin'].value['encrypted_password']
    enc_p and BCrypt::Password.new(enc_p) == p
  end
end
