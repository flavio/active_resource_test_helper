active_resource_test_helper
===========================

Simplifies Makes ActiveResource testing.

Usage
-----

active_resource_test_helper makes easier to use [ActiveResouce::HttpMock](http://api.rubyonrails.org/classes/ActiveResource/HttpMock.html).

Instead of declaring manually all the request-responses pairs it's possible to
use dynamically generated contents. These contents are defined using
[factory_girl](http://github.com/thoughtbot/factory_girl) and are stored into a
[Redis](http://code.google.com/p/redis/) database using [ohm](http://github.com/soveran/ohm).