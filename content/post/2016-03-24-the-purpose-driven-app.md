---
categories: [architecture]
date: 2016-03-24T16:10:27+08:00
title: The Purpose Driven App--What are people using your app for?
draft: true
---
Think of OOP

State is encapsulated, the only way to access them is through the object's interface

Why not the same for apps?

Polymorphism => enables plugin architecture

inheritance: code reusability
encapsulation: small interface footprint, reusable (like a gem?), blackbox (they can handle the message themselves, or thehy can delegate it or ignore it, but you don't care. it's like a personal assitant)
business logic: encapsulated, polymorphic

messaging is fundamental to object oriented programming. if you can say anything, you are effetively saying nothing. these principles limit what an object can say to another sos that each message is powerful and meanningful.

We'd be like Hal fixing the light switch (https://youtu.be/SY99U3cpsIw) - get a screwdriver, but the drawer squeaks, so you get the WD40, but it's run out so you get the car

flying spaghetti monster - tentacles all over the place



Story (talk about gratitude and appreciation)
1up - appreciation platform. add screenshots of the old app since 2008

Time for an upgrade

It's been 2 years in the making, ios and new website
current project => rails app, still ongoing, waiting for the UX implementation so it's still not deployed

One Fridat night my girlfriend had to attend a farewell dinner so I did whatever a geeky nerd would do when they don't have a date on Friday night - go make some interesting stuff

i've played around with the slack api before, i've got a notebook full of notes (link to senior developer blogpost)

i've joined a number of hackathons

thought i'd do a hackathoon and so i built a usable prototype in less than 24 hours using TDD

what's different?

no database - didn't need it (yet)
]minimal UI - let slack handle the ui display and input. the main payload was just text. so i just dealt with text as the primary input -- biggest work was on the boudnary objects: one to translate text input and parse it into something understandable, and another to then spit it out to a format that slack would be able to understand.

(drawing of the dependencies here)

it was not "complete"

there was no persistence => you can't do something like statistics or summaries
no leaderboards
no inventory of gifts received

it didn't have any of these. but it was usable

peopledidn't really care for these functions - not yet anyway.

They just wanted to be able to publicly appreciate their colleagues by giving them gifts.

Let that sink ini for a momment

All they wanted to do was to give gifts and have it publicly displayed

Whaat mae my version fo the appreciation platform so much more usable, whereas all the full-fledged projects that's being developed stagnated? Not that they didn't have good programmers working on it - they aree some of the best I've worked with.

The app fulfilled its purpose - give gifts and show it publicly.

Giving gifts is the primary purpose (or in agile terms, user story) of the app. there are definitely athers that weren't covered: lists, stats, leaderboards, admin interfaces, logins, etc.

It's just one of the many purposes that the app needs to fulfill. but it's the most important. it's the primary reason why you'd use the app.

You need to know the primary purpose of the software you're building.

This is a ruby conference so let's do some programming

Let's go down a parallel path for a moment and talk about objects

OOP pillars:
inheritancce
* makes code reusable, behavior can be shared across many objects
* some time ago inheritance receivedd a bad rap. now we have composition and stuff
* the original idea was about sharing behavior, not hiearchies. sub-typing is but one form of sharing behavior.

encapsulation
* giving a narrow and tight surface area to an object
* blackbox with only specific levers and switches to work with it - don't care how you do it, as long as I can ask youo to do it and you are able to do it

polymorphism
* ability to take on many forms
* facilitates a plugin architecture

let's take a toaster

put bread in, push the lever, wait for a few minutes, the a perfectly toasted bread comes out
the iphone of toasters

inheritance - it behaves lie other toasters, they all use the same prototype or blueprint.

encapsulation - one lever (and maybe a power switch)

polymorphism - you can plug in the toaster to any socket and it works

how about a frankentoaster?

you have to put in the bread using a tray and it goes in like a cd

many knobs an dials to lower the heating element, lower the bread, take out the bread etc

and it comes with a lightning connecter so you can charge the internal battery. battery life status indicator on the side.

you can play games on it too. it has a touch screen.

of course this is a joke, but it's a funny joke becasue it's obvious that the toaster (if you can call it that) is doing too much -- it's breaking  OOP.

Too much. Like a God Object. Like the FSM with its noodly appendages touching and manipulating everything else.

We design an object to do one thing and do it well. We design it to fulfill its purpose.

Why can't we do a similar thing for our apps?

Story time. Before i got my first programming job I waws doing programming as a hobby. I was contributing to this open source project that is an alternative client to a popular mmorpg that time.

we were doing reactive programming before it was called reactive.

quit my job as a restaurant manager to work in an area i am more passionate about

i couldn't get a job in programming because back then, you need to have a degree in CS or Engg. So I went for a 3 month bootcamp. got a scholarship after passing an aptitude test.

I remember during the scholarship interview, i was asked "have you done any programming before" I said i did. databases? no.

I remember the look on their faces and the emotion I felt when I realized what they were thinking. That I was incomplete.

Eventually I got to implement an ORM without really knowing about what an ORM is, mostly because I got tired typing the same SQL statements over and over. They didn't teach about Hibernate that time, just the concept of DAOs.

Why am I talking about this?

Because we have a bad habit of placing the database front and center of our apps.

I've experienced this myself. Whenever I start a new app, after Rails new I would immediately think of how my database models would connect with each other. There would be a `has_many` there, a `belongs_to` here. what would teh attributes be? indexes?

I knew what my app should be doing, what I'm supposed to be working on. But I don't work on it first. I thought I was, but I was actually doing busywork. I was focusing on the persistence layer first, instead of the business logic.

persistence - this is a secondary concern. Remember the appreciation platform? Users didn't care how I persisted the data. They did care that it *was*, just not *how* it was persisted.

as uncle bob would say: It's an implementation detail

going further, i thought about why i would immediately reach for rails. not that rails is bad.

i should create the BL first. that is what the users want. that is the reason why they went to the app in the first place - to get something they want to be done. whether it was used through the web, or through slack, or through a mobile app, or custom hardware, that really didn't matter as much.

treat our apps like objects. make them pluggable. delivery <= BL => persistence

rails, sinatra, rspec, web services, opal, rubymotion etc

BL

MySQL
Postgres
In memory hashtable
coredata
sqlite etc

dream: all of them can be interchanged. only change would be to the boundaries so the pieces can talk with each other.

they have their own purposes
delivery mechanism - to eliver the user's request to the business logic
persistence - to save state
business logic - _______ <- we fill in this one

Focus on your app's purpose. Do it first.

I was a mindshift for me. I had my failed starts before I got into ths way of thinking in terms of an app's purpose. There were habits that I had to unlearn, and new habits I had to form. This takes time, but I felt that I was much better going through being a beginner once again.

Someting to help with the transition: book Apprenticehip Patterns

Empty your Cup
Wear Your Whitebelt
Record / Share What You Learn

My favorite chapters of the book. TDD also helps, but that's a different discussion.

Let's stop making frankentoasters

Let's start making our apps fulfill what the users want to do. Find taht purpose and work on it first.

Let's build Purpose Driven Apps that consist of elegant, maintainable, and long-lasting code.















Abstract
========

We've heard about the mantra of the Object Oriented Programmer: objects should do one thing and do it well (aka the Single Responsibility Principle / the Unix Philosophy as applied to OOP). So why can't our applications follow the same concept?

Imagine if you can encapsulate your app's business logic. You'd be able to package it as a separate library. Your business logic will be independent of its input and output. You'd be able to mix and match between different frameworks--Sinatra, Rails, mobile, or even Slack.

You'd be able to compose application layers just like you'd compose objects.

Pitch
=====

I've been using Ruby for over 9 years, professionally programming in Ruby for over 6, and have had done programming in various other languages for over 20. I have seen programming paradigms come and go; discovered, forgotten, and then rediscovered.

Bob Martin mentions that the rate of programmer growth doubles every five years (http://blog.cleancoder.com/uncle-bob/2014/06/20/MyLawn.html) This means the Ruby community is, surprisingly, relatively young! It is of course no fault of the programmer for being young; that is to be expected and accepted. What would be the fault of the young programmer is to depend solely on their own experience; and in doing so neglect the lessons of the past.

With this talk I would like to challenge the audience's preconceptions on what application development with Ruby (especially with Rails) means. We've inherited a lot of hate for Java and C++ and all of those considered "boilerplate-heavy" languages, and snicker at the apparent over-engineering that results with using constructs such as interfaces and factories.

While there is indeed the issue of over-engineering (as with any other language, Ruby included) such abstractions came about as a solution to the problem of managing huge software applications. Most of us work on smaller scale apps; those that consult for startups work on a lot more of those small scale apps by the nature of their work. Only very few apps make it to the point where a solid architectural foundation makes a huge difference to its survival (and usually at this point the consultants have moved on to a different project, or the original programming team has earmarked the project for a rewrite).

Consequently, very few developers have actually experienced what it takes to scale your application to such scales. I'd like to show the audience some concepts, patterns and habits that experienced developers are using as part of their toolset to make software applications that are elegant, maintainable, and long-lasting.




