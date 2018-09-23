---
title: "Evaluating Hackerrank for Tech Hiring"
date: 2015-12-03
categories: [management]
---
We were looking at [Hackerrank](https://www.hackerrank.com) to see if they can help us with alleviating some of the interview and review load on our senior developers.
<!--more-->

Some observations:

* I feel this is a more "sophisticated" [FizzBuzz](http://c2.com/cgi/wiki?FizzBuzzTest) to filter candidates that only say they can program, but **in reality cannot**.
* The exercise by its nature **focuses on results**, not on some of the more (in my opinion) important metrics of code quality such as maintainability, readability, discipline, testability, etc.
* The time limit practically forces the applicant to **cowboy code**, instead of practicing their code discipline. I don't really want to get [cowboy coders](http://c2.com/cgi/wiki?CowboyCoder) into my team.
* (note: I experienced this with [Codility](https://codility.com/) and not in Hackerrank directly; but since they are in a similar niche I feel I can extrapolate from there) The harder algorithm problems test more of **whether you know a particular algorithm or not** (like splitting binary trees). Although such knowledge is great if you're making the next high-performance NoSQL database server or a Natural Language Processing library, it's less useful for web developer applicants. The danger is assuming that someone good at these kinds of "puzzles" would also be good at solving business problems; I feel it's just **not a good predictor**.
* Following on the previous point, there is a danger that since the hiring manager has all of these crispy numbers, that they would exclusively use these numbers as a **predictor for skill or aptitude; they're not**. These methods produce a high number of **false positives** (up until a certain level of applications) that I feel it's better to just invest in a more involved programming challenge (like what we do in [Mindvalley](http://mindvalley.com)). If we were getting hundreds of applications (with a wide skill variance) every week, then I think it would be worth it to filter using these challenges since the time savings will outweigh the risks of false positives. Right now, Mindvalley receives a drip of really high quality applicants that there's no need to test them on a FizzBuzz level.

I tried the questions for myself, with the time limit and all, to find out what kind of experiences the possible applicants would have. I was not able to finish all 4 questions within 30 minutes as I was doing [TDD](https://en.wikipedia.org/wiki/Test-driven_development), and had to figure out that I had to send my output to `STDOUT` for the checker to confirm my answers. I did eventually find out that the last two questions were actually `SQL` questions, which would have probably taken me around 10 to 15 minutes tops.

I'm not allowed to reproduce the questions, so I'm just pasting here my answers :P

```ruby
def lastLetter(word)
  word = word.strip
  last_two_letters = get_last_two_letters(word)
  reversed = last_two_letters.reverse
  result = reversed.split("").join(" ")
  puts result
  result
end

def get_last_two_letters(word)
  word[word.length - 2, word.length]
end

# require "rspec"
# require "rspec-given"

# describe "lastLetter" do
#   Given(:word) { "APPLE" }
#   context "getting the last two letters" do
#     When(:last_two_letters) { get_last_two_letters(word) }
#     Then { last_two_letters == "LE" }
#   end
  
#   context "getting the result" do
#     When(:result) { lastLetter(word) }
#     Then { result == "E L"}
#   end

#   context "edge cases" do
#     context "1 character long" do
#       Given(:word) { "a" }
#       When(:result) { lastLetter(word) }
#       Then { result == "a"}
#     end

#     context "last character is a space" do
#       Given(:word) { "a " }
#       When(:result) { lastLetter(word) }
#       Then { result == "a"}
#     end
#   end

# end
```

```ruby
def solvePuzzle(num)
  num = num.to_s
  result = num.split("").reduce(0) { |sum, num| sum + get_num_holes(num.to_i) }
  puts result
  result
end

def get_num_holes(num)
  return 0 if [1, 2, 3, 5, 7].include?(num)
  return 1 if [0, 4, 6, 9].include?(num)
  return 2 if [8].include?(num)
end

# require "rspec"
# require "rspec-given"

# describe "number of holes" do
#   context "solution" do
#     Given(:num) { "9899" }
#     When(:result) { solvePuzzle(num) }
#     Then { result == 5 }
#   end

#   context "zero hole" do
#     context do
#       Given(:number) { 1 }
#       When(:num_holes) { get_num_holes(number) }
#       Then { num_holes == 0 }
#     end
#     context do
#       Given(:number) { 2 }
#       When(:num_holes) { get_num_holes(number) }
#       Then { num_holes == 0 }
#     end
#   end

#   context "one hole" do
#     context do
#       Given(:number) { 0 }
#       When(:num_holes) { get_num_holes(number) }
#       Then { num_holes == 1 }
#     end
#     context do
#       Given(:number) { 4 }
#       When(:num_holes) { get_num_holes(number) }
#       Then { num_holes == 1 }
#     end
#   end
# end
```