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
    author { User.first or FactoryGirl.create(:user) }
  end

  factory :comment do
    content "hello world"
    author { User.first or FactoryGirl.create(:user) }
    post { Post.first or FactoryGirl.create(:post) }
  end

  factory :tag do
    name "ruby"
  end

  factory :mention do
    type 'post'
    link '/posts/12'
    content 'Hello World'
  end
end
