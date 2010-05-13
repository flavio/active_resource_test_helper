require 'test_helper'

User.destroy_all

100.times do
  Factory.create(:basic_user)
end

if User.count != 100
  warn("Error: 100 users should have been created")
  exit(1)
end

class ActiveResourceTestHelperTest < Test::Unit::TestCase
  include ActiveResourceTestHelper
  active_record_factories :basic_user

  def setup
    # make sure the User table is empty at the beginning of the test
    assert_equal 0, User.count
  end

  def test_create_some_users
    100.times do
      Factory.create(:basic_user)
    end
    assert_equal 100, User.count
  end
end