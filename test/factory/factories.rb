# https://github.com/thoughtbot/factory_girl/wiki/Usage

FactoryGirl.define do

  sequence(:name) {|n| "person-#{n}" }
  sequence(:email) {|n| "person-#{n}@example.com" }

  factory :profile do
  end

  factory :user do
    name
    email
    gravatar_id "xyz"
    profile { FactoryGirl.create :profile }
  end

  factory :post do
    title "yavaeye.com"
    link "http://yavaeye.com"
    user { User.first or FactoryGirl.create(:user) }
  end

  factory :comment do
    content "hello world"
    user { User.first or FactoryGirl.create(:user) }
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
