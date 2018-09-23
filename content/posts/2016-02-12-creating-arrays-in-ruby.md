---
date: 2016-02-12
title: Creating Arrays in Ruby
categories: [til, ruby, arrays]
draft: true
---
I love it when we hire new employees that are inquisitive and curious; they ask all those questions that make you stop and think a bit, and they wonder at how such a basic question can have a very complicated answer.

This week's interesting question was: What's the difference between these two ways of initializing Arrays (as taken from the [Ruby documentation](http://ruby-doc.org/core-2.2.0/Array.html#class-Array-label-Creating+Arrays))
<!--more-->
{{% opalbox %}}

{{< rubycode >}}
Array.new(3, Hash.new)
{{< /rubycode >}}

{{< rubycode >}}
Array.new(3) { Hash.new }
{{< /rubycode >}}