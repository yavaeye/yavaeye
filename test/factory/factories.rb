# https://github.com/thoughtbot/factory_girl/wiki/Usage
FactoryGirl.define do
  factory :user do
    name "yavaeye"
    email "yavaeye@gmail.com"
    credentials github: "xyz"
  end

  factory :post do
    title "yavaeye.com"
    link "http://yavaeye.com"
    author { User.first or Factory(:user) }
    tag { Tag.first or Factory(:tag) }
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
