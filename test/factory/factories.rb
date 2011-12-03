# encoding: UTF-8

Factory.define :user do |u|
  u.sequence(:openid){ |i| "http://me.yahoo.com/mm62xOv9#{i}" }
  u.sequence(:nick){ |i| "yavaeye#{i}" }
  u.sequence(:email){ |i| "yavaeye#{i}@gmail.com" }
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
