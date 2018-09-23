---
categories: []
date: 2016-06-02T16:57:36+03:00
description: ""
keywords: [TDD]
title: TDD and the Scientific Method
---

TDD's mantra is the following: Red, Green, Refactor. In other words: write a failing test, write code to make the test fast, and then make the code better (having the test as a safety net).
<!--more-->

Comparatively, here are the steps of the Scientific Method:

* Ask a Question
* Do Background Research
* Construct a Hypothesis
* Test Your Hypothesis by Doing an Experiment
* Analyze Your Data and Draw a Conclusion
* Communicate Your Results

There are many parallels between these two disciplines.

Writing a failing test can be compared to asking a question: "can my application do this?" with the constructed hypothesis being that "no, the application can't do this yet" (if it can, we just skip to the next iteration).

Writing the code to satisfy a test can be compared to doing the experiment to confirm the hypothesis.

Refactoring can be compared to drawing a conclusion and summarizing your results. Based on what you've learned on the behavior of the application, you can rearrange the code so it tells a much better story of the intention of the application.

Of course, it's not an exact parallel. You'd be scorned in the scientific community for filtering data and only using those that advance your hypothesis (see [Confirmation Bias](https://en.wikipedia.org/wiki/Confirmation_bias#Wason.27s_research_on_hypothesis-testing)) but otherwise, the similarities are striking.