# coding: utf-8

# store per-app specific preferences
class Pref < ActiveRecord::Base
  include Hstore

end
