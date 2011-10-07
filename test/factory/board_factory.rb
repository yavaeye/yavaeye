Factory.define :board do |b|
  b.name 'random board'
  b.description 'random board'
  b.active true
  b.user { User.first or Factory(:user) }
end

