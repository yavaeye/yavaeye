require_relative '../test_helper'

class Person
  include Mongoid::Document
  include Mongoid::Paginate
  include Mongoid::Timestamps
  include Mongoid::Token

  field :rank, type: Integer, default: 0
  token :length => 5, :contains => :alphanumeric
end

class MongoidPaginateTest < Test::Unit::TestCase

  def setup
    1.upto(20).each do |i|
      Person.create(rank: i)
    end
  end

  def test_paginate_with_default_order
    token = Person.last.token
    @people = Person.paginate_by_token(token)
    assert_equal 15, @people.to_a.size
  end

  def test_paginate
    token = Person.last.token
    @people = Person.paginate_by_token(token, order_by: :rank)
    assert_equal 15, @people.to_a.size
  end

  def test_paginate_with_options
    token = Person.last.token
    @people = Person.paginate_by_token(token, order_by: :rank, :rank.gt => 10)
    assert_equal 9, @people.to_a.size
  end
end

