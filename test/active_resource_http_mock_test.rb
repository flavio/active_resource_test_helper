require 'test_helper'
require 'active_resource'

class UserResource < ActiveResource::Base
  self.site = "http://example.com/"
  self.element_name = "user"
end


class RemoteUserTest < Test::Unit::TestCase
  include ActiveResourceTestHelper
  active_record_factories :basic_user
  
  def setup
    assert_equal 0, User.count
    @users = []
    20.times do |i|
      @users << Factory.create(:basic_user)
    end
  end

  def test_find_by_id
    @users.each do |expected_user|
      user = UserResource.find(expected_user.id)
      assert_not_nil user
      assert_equal expected_user.id.to_i, user.id
      assert_equal expected_user.first_name, user.first_name
    end
  end

  def test_should_return_404_if_user_does_not_exist
    assert_raise ActiveResource::ResourceNotFound do
      UserResource.find(@users.last.id.to_i + 100)
    end
  end

  def test_should_get_all_users
    current_users = UserResource.find(:all)
    assert_equal current_users.size, @users.size
  end

  def test_find_first_should_work
    user = UserResource.find(:first)
    assert_equal user.id, @users.first.id.to_i
  end

  def test_find_last_should_work
    user = UserResource.find(:last)
    assert_equal user.id, @users.last.id.to_i
  end

  def test_find_by_param
    Factory.create(:basic_user, :age => 18, :first_name => "flavio")
    Factory.create(:basic_user, :age => 28, :first_name => "flavio")

    users = UserResource.find(:all, :params => {:first_name => "flavio"})
    assert_equal 2, users.size

    users = UserResource.find(:all, :params => {:first_name => "flavio", :age => 18})
    assert_equal 1, users.size
    assert_equal "flavio", users.first.first_name
    assert_equal "18", users.first.age

    users = UserResource.find(:all, :params => {:first_name => "flavio", :age => 68})
    assert users.empty?
  end
end
