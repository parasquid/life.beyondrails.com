---
date: 2015-10-30T04:16:00-08:00
title: Codility - PermMissingElem
categories: [codility, til]
---

https://codility.com/programmers/task/perm_missing_elem

<!--more-->

### My solution

``` ruby
def solution(a)
  return 1 if a.empty?

  # edge case, N + 1 is missing
  # but unlike the case below, we can immediately compute and return this
  if a.length == 1
    return 2 if a[0] == 1
    return 1 if a[0] == 2
  end

  sorted = a.sort
  sorted.each_index do |index|
    return index + 1 if(sorted[index] != index + 1)
  end

  # edge case, N + 1 is missing
  return a.length + 1
end
```

### Learning points

* Edge cases are always tricky! Always get into the habit of asking: what can go wrong? Good questions to ask are: what about empty inputs, beginning/ending elements are missing.
* I have a feeling that for the other languages, you need to implement your own sorting algorithm (like bubble sort).