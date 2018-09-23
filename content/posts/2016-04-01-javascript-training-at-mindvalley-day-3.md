---
categories: [til, javascript, training notes]
date: 2016-04-01T10:23:17+08:00
title: Javascript Training at Mindvalley Day 3
draft: true
---
Today we do jQuery :)

CSS selectors

id selector `#foo`

class selector `.foo`

don't leave it a loose open query, unless you really need to

loose open query => just anything with the `foo` class

selecting a class without any precision will sleect all elements on the page

go for precision
* add a selector element (like `a`, `div`, `span`, etc)

the longer the query, the more precise it is. however, it will also take a longer time for the parser to process the query

`#foo div li a i` vs `#foo i`

`#foo a.bar i` or `#foo i.bar`

you should know how the dom is. will your query be too loose on other places of the dom?

wildcard selector - who uses this?
`.container *` but there are better ways to do this in jquery. you're probably doing something wrong.

adjacent selector
`ul + p` - element that is immediately followed by the element preceding the `+` sign

sibling selector
`ul ~ p`
it will continue selecting everything that matches the pattern (like the `+`) - similar to ruby regex match

direct child selector
selects the direct children of the parent element. any descendants of the children will not be selected.
consider `ul li` vs `ul > li` on menus and submenus

work top to bottom. be careful of inheritance.

attribute selecters
element[attr="value"]
allows the selection of elements based on its attributes
`div[title]` `<div title="foo">` title for tooltips

value equals
button[data-action="alert"] `<button data-action="alert">`

`data-` is a standard introduced for js devs to add attributes to elements and give meaning to them

value contains
button[data-action~="critical"] `<button data-action="alert critical red">`

substring contains
button[data-action*="alert"] `<button data-action="alert">` `<button data-action="critical-alert">`

just like regular expressions

value begins with `^=`
value ends with `$=`

pseudo selectors allow extra filtering (see CSS)




introduction to jquery

behaviour.js bennolan.com/behaviour
had the ability to bind events to dom elements by using css selectors

*prototype
*moo tools
*jquery -> now uses sizzle





document manipulation

strings

there is not much difference between single and double quotes (unlike bash or php where they have different meanings)
be consistent with singlel or double quoted strings

lots of string operations presented. i'll just refer to the documentation on how to use it. at least from what i can see js seems to be able to manipulate strings just like other programming langugaes (strings seem to be presenting itself as a character array)


what: document parts
how: change structure and content

css - manipulate appearance. css selectors can also be used to address document parts. using sizzle



dom also allows for navigational access









interesting.

$(document).children().children().children()
-> someone who's a beginner dev said "nothing" but that to me absurd, there's always a child element. but that's how a beginner looks at the world, and it's difficult for someone who's more experienced to look at the world like that. and that's why it's so difficult to teach beginners; just because you know something doesn't mean that you can teach it.




change structure and content
* modify html representation
* use a more comfortable api (vs the dom)

- creating new elements

`.parseHTML("<h1>Title</h1>")` => `$("<h1>Title</h1>")`


```
var e = $.parseHTML("<h1>Title</h1>")
$("div").append(e)
```
very strange output. is this a bug? mixing dom elements with jquery



`.before` `.after` vs `.insertBefore` `.insertAfter`

.prepend .append vs .prependTo .appendTo

.html vs .text

.wrap vs .unwrap **

.attr vs .data

do not add data attributes via `.attr` use `.data` consistently and not mix with dom manipulation (sounds like turbolinks?)

.val
.css
.hide
.show
.offset

.queue => access the selected element's task queue
every element can be associated with a queue where you can push tasks
queue is processed serially, so a callback function can block the execution of the page

api.jquery.com





wrap in $(function(){ ... }) because we don't know if its already parsed and loaded in the dom tree
we need to make sure the element we're selecting is already loaded into the dom tree
not like when document loaded - image loading, image dimensions

event listeners have a single argument evt (the event)
`this` will be bound to the dom element that signalled the event `evt.currentTarget`

phases:
* capture eventPhase = 1 (interecept event before it reaches the target)
* at target eventPhase = 2
* bubbling eventPhase = 3

subscribe to both table and td => both will trigger because of bubbling up

event bubbling => evt.stopPropagation



by default, events subscribe to the bubble phase




dom api => element.addEventListener("click", myFunction [, true])
duplicate registrations are ignored

jquery => $(sel).on("click", myFunction)
duplicate registrations are NOT ignored

events can be "tagged" (useful for bulk removal)
$(sel).on("click.circles.shapes.colours", myFunction)
$(sel).on("click.colours", myFunction) => will remove all events tagged "colours"


subselectors => to be able to subscribe to events that will need to be sibscribed to elements that haven't been created yet




useful events:
load vs ready
focusin focusout (bubble) vs focus blur (don't bubble)
















"good question, the short answer is yes you can use newlines, but i'll cover the long answer later in this lecture"
then reference the person asking the question later: "so he asked about newlines, and here is the long answer". it's about being present, not necessarily being right.

Some examples on real world use cases. How will we use this? (example: what are good uses for .stopPropagation? myabe ask the students about their own thoughts as well and then comment on whether they are on the right track or not, or even suggest an even simpler way to do what they are thinking of)