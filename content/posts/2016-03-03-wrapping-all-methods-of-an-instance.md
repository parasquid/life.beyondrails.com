---
categories: [til]
date: 2016-03-03T15:54:40+08:00
description: ""
keywords: []
title: Wrapping All Methods of an Instance
draft: true
---

```ruby
ApplicationController.class_eval do
  def self.inherited(klass)
    def klass.method_added(name)
      # prevent a SystemStackError
      return if @_not_new
      @_not_new = true

      # preserve the original method call
      original = "original #{name}"
      alias_method original, name

      # wrap the method call
      define_method(name) do |*args, &block|
        # before action
        puts "==> called #{name} with args: #{args.inspect}"

        # call the original method
        result = send original, *args, &block

        # after action
        puts "<== result is #{result}"

        # return the original return value
        result
      end

      # reset the guard for the next method definition
      @_not_new = false
    end
  end
end
```

### See also:
* http://blog.arkency.com/2013/07/ruby-and-aop-decouple-your-code-even-more/<br /> Going all out with Aspect Oriented Programming gives me the chills though; I'm starting to remember nightmares of huge Spring configuration files to make the Hibernate injections behave the way they're supposed to.

* **Ruby/Rails: Prepend, append code to all methods** http://stackoverflow.com/a/14403423<br />Out of all the answers to the original question, I prefer this answer. It mostly works but see below on how to correctly reopen the the `ApplicationController` class.

* http://juixe.com/techknow/index.php/2007/01/17/reopening-ruby-classes-2/<br />Instead of overwriting a class definitiin, reopen it instead.

* http://ruby-doc.org/core-2.2.2/Module.html#method-i-method_added<br />The hook where we get notified that a new method is being defined.
