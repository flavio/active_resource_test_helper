require 'test_helper'

class Dog < Ohm::Model
  attribute :name
  attribute :breed
end

class OhmModelChangesTest < Test::Unit::TestCase
  def setup
    Dog.destroy_all
  end

  def teardown
    Dog.destroy_all
  end

  def test_to_hash
    my_dog = Dog.new(:name => "Baguette", :breed => "Dachshund").save

    expected = {:breed=>"Dachshund", :name=>"Baguette", :id=>my_dog.id.to_i}

    assert_equal expected, my_dog.to_hash
  end

  def test_destroy_all
    101.times do |i|
      Dog.new(:name => "puppy #{i}", :breed => "Dalmatian").save
    end
    assert_equal 101, Dog.count
    Dog.destroy_all
    assert_equal 0, Dog.count
  end
end