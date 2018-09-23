---
date: 2016-01-03
title: Opalbox—Run Ruby Code Inside Pages
categories: [meta, opal]
---
[Opal](http://opalrb.org/) is a Ruby to JavaScript compiler, and [OpalBox](https://github.com/Angelmmiguel/opalbox-jquery) is a `jQuery` plugin to easily create a textarea that can take ruby code and allow it to run.

I just added OpalBox to this blog and it's been quite interesting. I've learned how to resize a `textarea` based on its content (you need javascript to do that because `CSS` just doesn't cut it) and I've added in a shortcode.

### update:
[Angelmmiguel](https://github.com/Angelmmiguel/opalbox-jquery) (the author of opalbox) has just released [0.1.0 that fixes the issue](https://github.com/Angelmmiguel/opalbox-jquery/issues/1) :)
<!--more-->
{{% opalbox %}}

Here's how it looks like:

{{< rubycode >}}
# this is ruby code
# it is inside a text area so you can edit it and play around with it

def square(x)
  x ** 2
end

puts square(256)

# click on run below to execute the code
{{< /rubycode >}}

I've edited one of my [past articles]({{< relref "post/2014-03-04-ruby-and-blocks.markdown" >}}) to use `OpalBox` if you're interested in how it looks like as a method for instruction.

Here's the javascript snippet that resizes the `textarea` to fit its content:
``` javascript
var $targets = $(".ruby-code textarea")
$targets.each(function() {
  $(this).height(0).height(this.scrollHeight - $(this).css("font-size").replace('px','')).change();
})
```

The `height` is first set to `0` because some browsers get confused with unconventional positions (negative margins, for example). It is then set to the `textarea`'s `scrollHeight`. I then subtract the `font-size` of this element to remove the extra line at the end.

[Shortcodes in Hugo](https://gohugo.io/extras/shortcodes/) (the blog engine this site is running on) is quite simple to make. It's just a `text` snippet that you can call within your article. For example, the above `OpalBox` looks like this:

<pre>
&#123;&#123;&lt; rubycode &gt;&#125;&#125;
# this is ruby code
# it is inside a text area so you can edit it and play around with it

def square(x)
  x ** 2
end

puts square(256)

# click on run below to execute the code
&#123;&#123;&lt; /rubycode &gt;&#125;&#125;
</pre>

While the shortcode file contents (`rubycode.html`) look like this:

<pre>
&lt;div class="ruby-code"&gt;&#123;&#123; .Inner &#125;&#125;&lt;/div&gt;
</pre>

I also have the `opalbox.html` shortcode that I only include whenever the article contains an `OpalBox`. It first runs the `.opalBox()` function on all `div` that have the class `.ruby-code` and turn them into `textarea`. Then the `textarea` are resized to fit their contents.

``` javascript
$(function() {
  $('.ruby-code').opalBox();
  var $targets = $(".ruby-code textarea")
  $targets.each(function() {
    $(this).height(0).height(this.scrollHeight - $(this).css("font-size").replace('px','')).change();
  })
});
```

## What I like

* It's great for tutorial articles that explain complicated concepts.
* The reader can play and manipulate the code to confirm understanding.

## What I don't like

* `textarea` disables syntax highlighting.
* Long ruby code is not practical because it looks like a wall of text.

## References:

Initial change to the article to include opalbox: https://github.com/parasquid/life.beyondrails.com/commit/996234fffc57a8e16ce7015abc00e3a374f00343

Changing the divs into a shortcode: https://github.com/parasquid/life.beyondrails.com/commit/20fe9761d285c448498ce5a1faef5f70edceed5a
