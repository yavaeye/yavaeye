# https://github.com/thoughtbot/factory_girl/wiki/Usage
FactoryGirl.define do

  sequence(:name) {|n| "person-#{n}" }
  sequence(:email) {|n| "person-#{n}@example.com" }

  factory :user do
    name
    email
    gravatar_id "xyz"
  end

  factory :post do
    title "yavaeye.com"
    link "http://yavaeye.com"
    author { User.first or Factory(:user) }
  end

  factory :comment do
    content "hello world"
    author { User.first or Factory(:user) }
    post { Post.first or Factory(:post) }
  end

  factory :tag do
    name "ruby"
  end
end
