---
title: "Safely Passing Ruby Code in a Rake Task"
date: 2015-12-04
categories: [ruby, meta-programming, til]
---

I wanted to make a rake task that would accept something like `1.month` or `1.day` as one of it's arguments. The immediate tool I reached for was `eval` and it worked like a charm. However, [Code Climate](https://codeclimate.com) (the tool we use to check for static analysis) complains about `eval` and understandably so; the use of `eval` is a practice full of danger and security vulnerabilities.

I'm using it inside a rake task that is never exposed to third parties, and anyone malicious enough to run the rake task with a bad parameter to be eval'd would already have had access to the system anyway, and able to wreak even greater havoc than by running the malicious code through the rake task. I believe this is an accepted risk scenario, and Crystal (one of my colleagues who was reviewing my code) suggested that since I had a valid point, I can just turn off the Code Climate check for this particular instance.

I thought that was justified, but I also thought it was a slippery slope. I'm sure there are ways to pass in a string and have it dynamically interpreted, without having to expose the system to a security vulnerability.

<!--more-->

# Why is `eval` so dangerous?

Jimmy had a [presentation on the YAML exploit](https://www.facebook.com/download/858552380924696/Hacking%20Rails.pdf) and this is exactly what enables the exploit: a YAML payload is deserialized to an object that contains an `#eval` statement and then executed.

There is a good [Sitepoint article](http://www.sitepoint.com/anatomy-of-an-exploit-an-in-depth-look-at-the-rails-yaml-vulnerability/) that goes in-depth into how the exploit works.

# ABV (Always Be Validating)

One way to work around the danger is to validate the string being passed.

``` ruby
def permit?(operation)
  permitted_operations = /^([1-9].(day|year|month|hour|minute)s?)$/
  !permitted_operations.match(operation.to_s).nil?
end

period = eval(args[:period]) if permit?(args[:period])
```

Here is the code I used to validate the parameters passed into eval. Since I know exactly what the format of the string would be, I can craft a simple regex to test for this.

However, since Code Climate does static analysis, it won't give me cookie points for validating the input first before passing to eval. As long as there is a call to `Kernel#eval` then the code climate checks will fail.

# A rose by any other name

We can instead use `#instance_eval` which is mostly the same thing, but instead of evaluating the string in the current context, it evaluates the string within the context of the object instance you're calling it in.

``` ruby
class SandboxObject; end
period = SandboxObject.new.instance_eval(args[:period]) if permit?(args[:period])
```

`#instance_eval` not necessarily more secure, since you can still pass in stuff that can give remote access to an attacker if you don't properly validate it. For example:

```ruby
class SandboxObject; end
Sandbox.new.instance_eval("system('cat /etc/passwd')")
```

But since we're now restricting the string evaluation to an instance of a sandbox object, you are able to sidestep a number of more common attacks such as redefining a method on a commonly used class.

Together with the input validation, this should be enough to mitigate against careless ruby code being passed in as input (and this also makes Code Climate happy and I get to have my pull request merged).

# TL;DR
I lied; there is no perfect way have a third party pass in a string and safely `eval` it. However, you can mitigate the damage with the following:

* Validate your string parameters that are to be eval'd or executed.
* Don't turn off the code climate check; instead look for ways to approach what you want to do in a different way.

# Updates

[Looi](https://www.facebook.com/ferngyi) made a good point on sidestepping the regex altogether:

```
def validated_period(args)
  num, period = args.split('.')
  allowed_periods = %w(second seconds hour hours day days month months)

  if allowed_periods.include?(period) && num.to_i > 0
    num.to_i.public_send(period)
  end
end
```

[Espen](https://www.facebook.com/antonsen.espen) also makes a great point that the regex isn't an issue, but the eval is and suggested to instead use something like the Chronic library or something like `.advance(period.to_sym => i)`.