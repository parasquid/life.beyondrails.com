---
date: 2016-02-05
title: String Interpolation with Templates Using String#
categories: [til]
---
I was working on a feature for [upcloudify](https://github.com/parasquid/upcloudify) that will use Slack notifications instead of email notifications. One of the challenges I faced was how to build-in flexibility for generating messages. I would want that the user be able to provide their own custom notification message, but at the same time be able to provide placeholders for items like the S3 download link.
<!--more-->
{{% opalbox %}}

I initially thought of using an `ERB` template but then realized it will be far too overkill for this simple purpose. I actually just needed to have the caller be able to provide a template string, and then merge certain variables into this template string.

I started playing around with regexes when I came upon [String#%](http://ruby-doc.org/core-2.2.0/String.html#method-i-25)

From the documentation:

> Format—Uses _str_ as a format specification, and returns the result of applying it to _arg_. If the format specification contains more than one substitution, then _arg_ must be an `Array` or `Hash` containing the values to be substituted. See `Kernel::sprintf` for details of the format string.

```ruby
"%05d" % 123                              #=> "00123"
"%-5s: %08x" % [ "ID", self.object_id ]   #=> "ID   : 200e14d6"
"foo = %{foo}" % { :foo => 'bar' }        #=> "foo = bar"
```

I thought this was very cool. Let me show you what I mean:

{{< rubycode >}}
template = "Hello %s!"

puts template % "World"
{{< /rubycode >}}

You can also use an array to feed the template:

{{< rubycode >}}
template = "Because Oct %o = Dec %d"

puts "Why do programmers always mix up Halloween and Christmas?"
puts template % [25, 25]
{{< /rubycode >}}

For an even better template that doesn't depend on the order of the elements, you can feed in a `Hash`:
{{< rubycode >}}
template = "
Q: What's the %{programming_paradigm} way to become wealthy?
A: %{answer}"

puts template % {programming_paradigm: "Object Oriented", answer: "Inheritance"}
{{< /rubycode >}}

**Note:** Sadly, OpalBox doesn't seem to work well with this particular usage of `String#%` since [Opal 0.7.1 has a bug](https://github.com/opal/opal/issues/678) where it doesn't properly interpolate named parameters (I've already [reported this](https://github.com/Angelmmiguel/opalbox-jquery/issues/3) to the opalbox author). I will update this article whenever the issues have been ironed out.

Runnning the code in `IRB` works however:

```ruby
puts template % {programming_paradigm: "Object Oriented", answer: "Inheritance"}
# Q: What's the Object Oriented way to become wealthy?
# A: Inheritance
```

The method is also written in C (at least for MRI) so it's expected to be fast.

```ruby
puts Benchmark.measure { "Hello %s" % "World" * 6_000_000}
#  0.010000   0.040000   0.050000 (  0.051013)
```

In the end the code for the feature I was working on looked like this:

```ruby
# gem source
def upload_and_notify(filename: nil, attachment: nil, message: "%s")
  raise ArgumentError "filename cannot be nil" unless filename
  raise ArgumentError "attachment cannot be nil" unless attachment

  expiration = (Date.today + 7).to_time
  file = @uploader.upload(filename, attachment)
  @notifier.notify(text: message % file.url(expiration))
end

# spec file
context "the notification can merge the file url" do
  When { expect(notifier).to receive(:notify).with({text: "your report <filename link>"}) }
  Then {
    expect {
      instance.upload_and_notify(filename: 'abc', attachment: '123', message: "your report <%s>")
    }.not_to raise_error
  }
end
```

## See also:
* http://ruby-doc.org/core-2.2.0/String.html#method-i-25
* http://ruby-doc.org/core-2.2.0/Kernel.html#method-i-sprintf
* http://blog.revathskumar.com/2013/01/ruby-multiple-string-substitution-in-string-template.html
* http://davebaker.me/articles/tip-ruby-string-interpolation-with-hashes

## TLDR;
`String#%` is a cool and flexible way to store a template in a string so you can defer the string interpolation.
