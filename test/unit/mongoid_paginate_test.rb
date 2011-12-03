require_relative '../test_helper'

class Person
  include Mongoid::Document
  include Mongoid::Paginate
  include Mongoid::Timestamps
  include Mongoid::Token

  field"rank", type: Integer, default: 0
  token :length => 5, :contains => :alphanumeric
end

class MongoidPaginateTest < TestCase

  def setup
    1.upto(20).each do |i|
      Person.create!(rank: i)
    end
  end

  def test_paginate
    people = Person.paginate("order_by" => "rank")
    assert_equal 15, people.to_a.size
  end

  def test_paginate_with_pagenum
    people = Person.paginate("order_by" => "rank", "pagenum" => 1)
    assert_equal 15, people.to_a.size
    people = Person.paginate("order_by" => "rank", "pagenum" => 2)
    assert_equal 5, people.to_a.size
    people = Person.paginate("order_by" => "rank", "pagenum" => -1)
    assert_equal 15, people.to_a.size
    people = Person.paginate("order_by" => "rank", "pagenum" => 3)
    assert_equal 0, people.to_a.size
  end

  def test_paginate_by_token
    people = Person.paginate_by_token("order_by" => "rank")
    assert_equal 15, people.to_a.size
    token = Person.first.token
    people = Person.paginate_by_token("token" => token, "order_by" => "rank")
    assert_equal 0, people.to_a.size
  end

  def test_paginate_by_token_with_options
    token = Person.last.token
    people = Person.paginate_by_token("token" => token, "order_by" => "rank", :rank.gt => 10)
    assert_equal 9, people.to_a.size
    people = Person.paginate_by_token("token" => token, "order_by" => "rank", :rank.gte => 10)
    assert_equal 10, people.to_a.size
  end

  def test_paginate_by_token_with_default_order
    token = Person.last.token
    people = Person.paginate_by_token("token" => token)
    assert_equal 15, people.to_a.size
    assert_equal false, people.to_a.any? { |person| person.token == token }
  end
end

