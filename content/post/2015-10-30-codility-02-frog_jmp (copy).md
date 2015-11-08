---
date: 2015-10-30
title: Codility - FrogJmp
categories: [codility, til]
---

https://codility.com/programmers/task/frog_jmp

<!--more-->

### My solution

``` ruby
def solution(x, y, d)
  ((y - x).to_f / d).ceil
end
```

### Learning points

* Paper and pencil (and algebra) helps. The equation is: `x + dn >= y` After that it was just a matter of finding `n`.
* Integer division can be tricky. Convert to `float` to retain precision, then convert back to `integer` afterwards (if the situation requires it).
* `#to_i` will chop off the decimal portion of the float; this may or may not be what you want.
* `O(1)` will usually mean there should be no loop used -- at all. It is a straightforward computation.
