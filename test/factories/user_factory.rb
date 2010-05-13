require 'test_helper'

Factory.define_active_resource_factory(:basic_user, :class => "User") do |u|
  u.sequence(:first_name) {|n| "first_name#{n}"}
  u.sequence(:last_name) {|n| "last_name#{n}"}
  u.admin false
  u.email {|u| "#{u.first_name}.#{u.last_name}@example.com" }
  u.age {rand(30) + 18}
  #u.association :pet, :factory => :pet
end