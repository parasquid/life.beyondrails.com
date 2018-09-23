---
categories: [til, javascript, training notes]
date: 2016-03-18T15:54:40+08:00
title: Javascript Training at Mindvalley Day 2
---
We've commissioned [Dekatku](http://www.dekatku.com/) to train some developers here at [Mindvalley](http://www.mindvalley.com/) on Javascript, and it's been a great experience so far! Today is Day 2 of the the training and we've covered some really deep topics.

I've started [wearing my whitebelt](https://www.safaribooksonline.com/library/view/apprenticeship-patterns/9780596806842/ch02s02.html) again and I thought I'll put up my thoughts and notes here for future reference.
<!--more-->
At the start of the session we had one hour to make a TODO application. The caveat being that we're not allowed to use any libraries or frameworks; just pure javascript.

How did it go? I realized (yet again) that raw javascript is very verbose! I looked at the output of my code and there was so much `document.getElementById()` calls everywhere.

I knew what to do, but I didn't have the vocabulary to express it.

I found that it was good to go back to fundamentals and try to rebuild what you've been using utilizing only the basic building blocks of the technology. It gave me a better appreciation of the work that libraries and frameworks saved me, but more importantly: **it gave me the confidence to walk by myself without a crutch**; whatever these libraries are doing isn't magical anymore, and I can rebuild (or debug) them myself.

We then went on to the two different types of expressions in Javascript:

* `expression` => produces a value
* `statement` => performs an action

For some reason it reminded me of the [command/query separation](http://martinfowler.com/bliki/CommandQuerySeparation.html) by Bertrand Meyer.

Of course, what's some Javascript without surprising behavior:
``` Javascript
{} + []
//=> 0 but it's an [object Object] so it's true(thy)
```

Good piece of advice: **deal with an exception, or throw it back out**

Some food for thought by Tim when I asked a question about whether you can catch hierarchichal errors:

> "The answer is no, but yes." -- Timothy

> [Like everything else in Javascript, it would seem. -- Tristan]

Fun facts:

* every function in javascript is variadic
* javascript has a "moveable" `this` (functions can be bound to any object)

More syntactic sugar:
``` Javascript
x.foo(args) => x.foo.call(x, args)
```

The `call` function from `Function.prototype` sounds very much like `#instance_exec` from Ruby.

* https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Function/call
* http://blog.bigbinary.com/2010/05/28/instance-exec-changing-self-and-parameters-to-proc.html

Words of warning: Don't mess with the global scope. That's why we have this pattern:
``` Javascript
(function(){})();
```

Now we have lunch :)

---

After lunch, things get more exciting as we start diving deeper into the Javascript object model.

Javascript has no formal notion of classes and inheritance, but you can make it behave similar to that:

``` Javascript
function LifeForm() {
  this.name = "";
  this.description = "";
  this.setName = function(name) {
    this.name = name;
  };
  this.getName = function() {
    return this.name;
  };
};
var lifeForm = new LifeForm();

function Human() {
  LifeForm.call(this);
  this.arms = 2;
  this.legs = 2;
};

Human.prototype = Object.create(LifeForm.prototype);
// => this changes the class "definition"
```

More words of wisdom:

> Managing scope in OOJavasctipt is very important, especially in async code (which use callbacks a lot) -- Björn

Surprising stuff: you can change an object's prototype and it will change all objects derived from that prototype, even ones that's already been created.

``` Javascript
var baz = function bar() { }
Function.prototype.foo = function() {
  console.log("hello!");
}
baz.foo();
//=> hello
```
This is very similar to how ruby works with `#class_eval`

``` Ruby
class Bar; end;
Class.class_eval do
  def foo
    puts "hello"
  end
end
Bar.foo #=> "hello"
```

Note that even though the class `Bar` was created _before_ we reopened the class `Class` (which in Ruby is similar to the prototype of the object `Function`) it still managed to call the `#foo` method.

What's a class without Homework:

* Using everything you've learnt today, create a set of classes which represent vehicles.
* Must have 3 levels hierarchy.
* Submit by Wednesday 23 March.

---
Super thanks to:

* Björn Karge https://www.linkedin.com/in/bjornkarge
* Timothy Chandler https://www.linkedin.com/in/timothy-chandler-7625b823
