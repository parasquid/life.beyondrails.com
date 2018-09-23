---
categories: []
date: 2016-04-22T10:26:10+08:00
title: Javascript Training at Mindvalley Day 6
draft: true
---

Today we're learning about HTML5 stuff :)

AJAX - surprisingly came from Microsoft (at that time you'd think that MS was only trying to kill off other technologies so they can become a monopoly)

We no longer bother with polyfill or testing if the browser is IE - just let the browsers fail. Force the browser manufacturers to adhere to the standards.

Same Origin Policy - for protection from CSRF (it's hard for the server to ensure that it's sending data to the correct client)

JSONP -> still risk of CSRF (Rosetta Flash)

CORS -> also requires cooperation from the API provider. The implementation depends on the browser - you can create your own browser and ignore the SOP restrictions

DATA URIs and BLOB URIs

AJAX HTTP errors go to xhr.status / xhr.statusText but not all errors are HTTP errors

jQuery.load() -> optional selector, can load a remote document and select specific things from it and replace the HTML

Full Screen APIs are non-standard -> means you need to keep an eye on the changing standard (code can break overnight)

History API - manipulate the active session history (within one tab) --> usuallt used by SPA (like gmail)
state - when the browser is refreshed, the url will be loaded and so the app needs to be able to load content at the particular location

use the page onLoad event and fetch the history.state if you need it at the beginning of the page's lifecycle

Drag and Drop
elements you want to be draggable must have the `draggable` attribute
events will be fired for every pixel movement, use sparingly

TicTacToe with history of moves

Dragula (drag and drop library for js https://github.com/bevacqua/dragula)

There's OO js and there's vanilla js -> it's quite difficult to understand OO at this point (imperative seems easier and more intuitive)