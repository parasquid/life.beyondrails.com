---
date: 2015-10-30
title: Codility - TapeEquilibrium
categories: [codility, til]
---

https://codility.com/programmers/task/tape_equilibrium

<!--more-->

### My solution

``` ruby
def solution(a)
  first_sum = a[0]
  second_sum = a[1..-1].reduce(0, :+)
  min_diff = (first_sum - second_sum).abs

  a.each_index do |p|
    next if p == 0
    next if p == a.length - 1

    first_sum = first_sum + a[p]
    second_sum = second_sum - a[p]
    diff = (first_sum - second_sum).abs
    min_diff = diff if diff < min_diff
  end

  min_diff
end
```

### Learning points

* Take note of the complexity and how additional magnitude might creep in (e.g. using `#reduce` inside the `#each_index` block).
* Recomputing over and over is wasteful. Try to find ways to cache values and manipulate them within the complexity. In this case, the sums are cached and the element under the moving index added and subtracted accordingly. This avoids recomputing the `first_sum` and the `second_sum` for every loop iteration.
* Take care of edge cases. In this case, since the `first_sum` and the `second_sum` had already been precomputed, we need to skip them during the loop iteration.