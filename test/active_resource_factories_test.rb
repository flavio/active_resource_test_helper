require 'test_helper'

Factory.define_active_resource_factory(:book) do |b|
  b.sequence(:author) {|n| "author foo#{n}"}
  b.sequence(:title) {|n| "title#{n}"}
  b.sequence(:genre) {|n| "genre #{n}"}
  b.pages {rand(500) + 30}
end

Factory.define_active_resource_factory(:fantasy_book, :parent => :book) do |b|
  b.genre "fantasy"
  b.pages {rand(500) + 130}
end

class ActiveResourceFactoriesTest < Test::Unit::TestCase
  def setup
    Book.destroy_all
  end

  def teardown
    Book.destroy_all
  end

  def test_factory_should_be_defined
    assert_not_nil Factory.factory_by_name(:book)
    assert_not_nil Factory.factory_by_name(:fantasy_book)
  end

  def test_model_class_should_be_defined
    assert_nothing_raised do
      assert_not_nil Book.new
    end
    assert_raise NameError do
      FantasyBook.new
    end
  end

  def test_factory_create_works
    assert Book.all.empty?

    Factory.create(:book)
    assert_equal 1, Book.all.size

    fbook = Factory.create(:fantasy_book)
    assert_equal 2, Book.all.size

    assert_equal "fantasy", fbook.genre
  end

  def test_model_attributes
    book = Book.new
    assert(book.attributes.include?(:author))
    assert(book.attributes.include?(:title))
    assert(book.attributes.include?(:pages))
    assert(book.attributes.include?(:genre))
  end

  def test_model_indices
    book = Book.new
    assert(book.indices.include?(:author))
    assert( book.indices.include?(:title))
    assert( book.indices.include?(:pages))
    assert( book.indices.include?(:genre))
    assert( book.indices.include?(:id))
  end

  def test_model_has_save!
    book = Book.new
    assert( book.methods.include?("save!"))
  end
end