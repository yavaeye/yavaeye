# encoding: UTF-8

require_relative "../test_helper"

class HstoreTest < TestCase
  def setup
    @profile = create :profile, read_posts: {a: 1}, marked_posts: {b: 2}
  end

  def test_hstore_update
    @profile.hstore_update! :read_posts, {a: 3}
    @profile.hstore_update! :marked_posts, {}

    @profile.reload
    assert_equal '3', @profile.read_posts['a']
    assert_equal '2', @profile.marked_posts['b']
  end

  def test_hstore_delete
    @profile.hstore_delete! :read_posts, :a
    @profile.hstore_delete! :marked_posts, :a
    
    @profile.reload
    assert @profile.read_posts.empty?
    assert_equal '2', @profile.marked_posts['b']
  end
end
