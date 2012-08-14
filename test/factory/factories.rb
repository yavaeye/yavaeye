# https://github.com/thoughtbot/factory_girl/wiki/Usage

FactoryGirl.define do

  sequence(:name) {|n| "person-#{n}" }
  sequence(:gravatar_id) {|n| Digest::MD5.hexdigest "person-#{n}@example.com" }

  factory :profile do
  end

  factory :user do
    name
    gravatar_id
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
    content 'Hello World'
    content_href '/posts/12'
  end
end
