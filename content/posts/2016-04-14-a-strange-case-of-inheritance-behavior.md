---
categories: [til, inheritance]
date: 2016-04-14T20:27:59+08:00
title: A Strange Case of Inheritance Behavior
---
While working some code to work with the Zuora SOAP API, I got bit by a strange case of inheritance behavior. It would seem that this is related to what `self` is bound to during the execution of the statement. Here it is, distilled to its essentials:
<!--more-->
{{% opalbox %}}

{{< rubycode >}}
class Parent
  def self.foo
    "parent foo"
  end

  def self.bar
    puts "parent bar"
    puts self.foo
  end
end

class Child < Parent
  def self.foo
    puts "child foo"
  end

  def self.bar
    puts "child bar"
    super
  end
end

puts Child.bar
{{< /rubycode >}}

Intuition will tell you that when you call `Child.bar`, since the method called `super` you would remain in the `Parent` context. So when the `Parent.bar` method called `self.foo` you would expect it to be kept in the same context.

This is in fact not the case; it is as if the binding of `self` remains with the `Child` class, that is why even if the `self.foo` was called in the `Parent` class the `Child.foo` was called instead.

I asked my colleague [Aaron](http://aaronmyatt.github.io/) who was once a Python programmer to give me an equivalent Python code to run:

``` python
class Parent(object):
	def foo(self):
		print("Parent foo")
	def bar(self):
		print("Parent bar")
		return self.foo()

​class Child(Parent):
	def foo(self):
		print("Child foo")
	def bar(self):
		print("Child bar")
		return super(Child, self).bar()

c = Child()
print(c.bar())
```

And the output was the same:

``` python
Child bar
Parent bar
Child foo
```

I'm not an expert Javascript programmer so I'm curious how an equivalent program would behave under Javascript.

### Update:

[Lee Siong Tai](https://www.facebook.com/noob.kido) kindly provided me a fiddle here: http://www.es6fiddle.net/in0c3zsi/ and interestingly, it shows the same behavior.

[Jimmy Ngu](https://www.facebook.com/jimmyngu) also has some interesting links, go check out our discussion at https://www.facebook.com/groups/klxrb/permalink/792231597575468/
