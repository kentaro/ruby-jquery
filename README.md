# ruby-jquery  [![BuildStatus](https://secure.travis-ci.org/kentaro/ruby-jquery.png)](http://travis-ci.org/kentaro/ruby-jquery)

ruby-jquery is a jQuery expression genelator.

## Synopsis

```ruby
require 'jquery'

jQuery()                                       #=> jQuery()
jQuery('a')                                    #=> jQuery("a")
jQuery(:document)                              #=> jQuery(document)
jQuery('a').text()                             #=> jQuery("a").text()
jQuery('a').text('aaa')                        #=> jQuery("a").text("aaa")
jQuery('a').foo(['a', 'b'])                    #=> jQuery("a").foo(["a","b"])
jQuery('a').foo({'a' => 'b'})                  #=> jQuery("a").foo({"a":"b"})
jQuery('a').click(->(f) { f.e 'return true' }) #=> jQuery("a").click(function (e) { return true })
```

## With Selenium Driver

You can use this library with [Selenium Driver for Ruby](http://code.google.com/p/selenium/wiki/RubyBindings) like below:

```ruby
driver.execute_script(
  "return " . jQuery('#content a').attr('href')
)
```

## Installation

Add this line to your application's Gemfile:

    gem 'ruby-jquery'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install ruby-jquery

## TODO

  * Support property access (e.g. `jQuery.ajax(...)` and `jQuery('a').length`). But can I do it with Ruby?

## See Also

  * [String-jQuery](https://github.com/motemen/String-jQuery)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
