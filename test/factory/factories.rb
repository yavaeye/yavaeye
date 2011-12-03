# encoding: UTF-8

Factory.define :user do |u|
  u.sequence(:nick) {|n| "yava#{n}"}
  u.gravatar_id "7777fb"
  u.credentials github: "xyz"
end

Factory.define :board do |b|
  b.name 'random'
  b.description 'random board'
  b.active true
  b.user { User.first or Factory(:user) }
end

Factory.define :post do |p|
  p.title 'yavaeye.com'
  p.link 'http://yavaeye.com'
  p.user { User.first or Factory(:user) }
  p.board { Board.first or Factory(:board) }
end
