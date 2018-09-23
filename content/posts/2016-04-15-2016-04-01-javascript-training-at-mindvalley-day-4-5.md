---
categories: []
date: 2016-04-15T10:07:44+08:00
description: ""
keywords: []
title: 2016 04 15 2016 04 01 javascript training at mindvalley day 4 5
draft: true
---

The problem with the web today is we large sites that have unwieldly dependencies. Conflicts, global scope tangling.

Today we learn about making code more manageable.

Web Modules - can be a solution for managing large and numerous scripts

CommonJS / Asynchronous Module Definition - aim to define a common set of APIs

exports global variable exposes your API

company/project or project/module - standard for identifier namespaces

CommonJS is not web friendly and is Synchronous




npm install --save-dev grunt
npm install --save jquery


grunt-init (v0.3.2) nukes package.json and writes a new one!!

commonjs vs AMD vs requirejs vs amadala
grunt vs gulp
bower vs browserify vs webpack
npm vs jspm


Lunch Break


Javascript prototype chain is always linear

Interfaces

* defined solely by abstract behavior
* a type of "contract"

Seems to be very difficult to implement in javascript due to the prototype pattern. Maybe we should just not shoehorn class-based inheritance of behavior into prototype-based inheritance of behavior?

JSKK vs ECMAScript 2015 class-based

when you change/assign A.prototype then every object created from A will have that prototype (share the behavior)





unit testing

what's a unit? -> a pure function that always gives you the same result for a given input



npm + browserify -> webpack



get the precompiled bootstrap and stick it somewhere
sometimes you can, but you should not, include the prepackaged minified file (when you run it with the minifier again, it will error and die)

try and breakup your less files a bit
try to override some of the basic bootstrap stuff

you can do the generic website or try and upgrade the todo list
curious to see what you can come up with

do a multi page site and try to create an mvc (using jskk?)

what is going on with all the nesting (messy with requirejs) -> level of the dependencies, because the loading is done asynchronously (call back hell?)

bootstrap has a dependency on jquery, so jquery needs to load first (how to solve this?)