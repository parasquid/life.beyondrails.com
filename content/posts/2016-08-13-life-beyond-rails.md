---
categories: [featured, presentations]
date: 2016-08-13T15:00:00+08:00
title: "Life Beyond Rails: Building Cross Platform Applications"
---
This is the talk I presented during the first [Ruby Conference in Kuala Lumpur](http://rubyconf.my/), Malaysia. It's not a word-for-word transcription, but this is mostly the same material I wrote to prepare for the talk.


![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-001.resized.jpg)

The secret to creating cross platform apps is something you already know, but probably not doing.

<!--more-->

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-002.resized.jpg)

I used Ruby to write a streaming app, a request-response app, a client-side web app, and a mobile app.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-003.resized.jpg)

I'm Tristan, and I'm the Chief Problem Solver at [Mindvalley](http://www.mindvalley.com/). You can find me on facebook and github @parasquid.

Like many of you, I was a self-taught programmer. It all started many years ago when I was around 9 or 10; my father had an Apple ][+ clone called Minta ][ and I spent many nights typing in programs in BASIC from Byte magazine.

After that, came QBasic in high school (I was fortunate to have studied in a more technical school that taught programming and Wordstar, among other things) as well as C/C++ and dBase/Clipper.

After that, I joined an opensource project that was primarily in Perl and picked that up. Around 2005 the project leader introduced me to Ruby and I remember telling him "It's just like Perl!" and promptly forgot about it.

I picked up Java for a job I had in a VAS (valu-added services) company--we were making apps before they were cool--handling the applications that respond when you send an SMS to 2467. Then I rediscovered Ruby because of Mindvalley, and at that time also got introduced to Rails.

Unfortunately (or fortunately, as some might think) I skipped PHP altogether so I don't have as much of horror developer stories as the rest of us. :)

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-004.resized.jpg)

But now, I love Ruby. Its currently my favorite language. It's the hammer I use to solve all the problems that come my way.

If I can just use Ruby all the time, not just for web but also on the frontend, and in mobile, I'll be happy.

Then I thought, hey that's a challenge! So I did, and that was the small project I made.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-006.resized.jpg)

So that's it! It's proof that ruby is cross platform! We can now tell everyone we can also do mobile development, we just need to learn how to compile ruby using RubyMotion.

Right?

The thing is, I think the meaning of "cross platform" is usually misunderstood.

What does cross platform really mean then?

In order to understand that, we need to know what cross platform isn’t.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-007.resized.jpg)

What does Voyager 2, your legacy Rails app, and your hackathon prototype have in common?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-008.resized.jpg)

They're [dead end products](https://www.witforsale.com/post/2016/06/09-dead-end-products/).

When the Voyager 2 was made, they didn't intend to repair or update it after launch. If there was any glitch or malfunction, the only way to fix it was to launch another probe.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-009.resized.jpg)

In some ways, it made the design process so much easier.

The power cells can be directly welded to the modules because they'll never be taken apart anyway.

So what if the antenna can only operate on a fixed frequency? There's no need for a tuning knob because it will never be retuned.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-010.resized.jpg)

Then again, Voyager 2 will never change, and will never be used for a different purpose.

You're not touching your legacy Rails app because you "don't fix it if it ain't broke," and you'd prefer to just rewrite it from scratch anyway.

Your hackathon prototype works well for the pitch, but it is not suited for production purposes.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-011.resized.jpg)

It's the same with your code.

Ask yourself the question: can you reuse a significant portion of the code you wrote if, by some magical means you can suddenly run your code in a different platform?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-012.resized.jpg)

Cross platform means absolutely nothing if you can't reuse your code.

I'll repeat this again, and you know it's important because I said it twice.

Cross platform is useless if your code can't be reused.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-013.resized.jpg)

Interesting isn't it? What benefit is it that ruby runs on an iOS device when you have to rewrite the whole codebase from scratch anyway?

You might as well just learn swift and do it the way apple wants you to do it.

Reuse of prior work across multiple platforms is the biggest reason why you want cross platform support.

So how do you design your code so that it is reusable?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-014.resized.jpg)

Let's take a look at the calculator.

Notice how the UI and the domain logic are separate. How in this example, we put the React UI, while in this example, we put the telnet UI and here, we put the iOS ui.

It's almost as if you're just able to just swap things  around just like that!
Right?

Do you know what this reminds me of?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-015.resized.jpg)

This. A USB cable.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-016.resized.jpg)

I can use the same cable to charge a cellphone, a powerbank, a camera, and various other things.

They all follow the same standard so they are all interchangeable.

And I don't have to know which pin of the USB connects carries the electricity--I just know that if I plug one end to a power source and the other end to the device, it will charge.

Nobody would think of making a phone that has its power cable attached and not detachable. Well maybe Apple might.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-017.resized.jpg)

In majority of the cases, the cross platform problem is solved in the physical world. We intuitively understand how to design products that can be reused.

But because software is intangible it's difficult to apply our experience as meatbags to the act of creating software.

So what can we take from designing physical products and apply it to software development?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-018.resized.jpg)

Let's take a look at the USB cable example again.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-019.resized.jpg)

Remember when I said they all follow the same standard? That means the USB cable can treat different objects in the same way.

They all have the same USB interface, so from the point of view of the cable, they're all the same thing (even though they're not).

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-020.resized.jpg)

How about when I said that I don't need to care about the electromotive force or which pins carry the electricity?

That means I don't even have to know how the cable was made in order to use it! I also immediately know that the cable is not for drying my hair, or for opening a can.

It was less complicated because the list of things I can do with the cable was small, and the kinds of things I can use the cable with was also limited.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-021.resized.jpg)

In effect, you’re replacing the questions on the left with this one question on the right.

You’re reducing the surface area of the complexity involved.

I think some of you would already know where I’m going here.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-022.resized.jpg)

Instead of asking how does this work, or which things can I use this with, I now just ask: what can this do?

* Encapsulation: What vs How
* Polymorphism: What vs Which

These two might sound familiar. You'd know them from Object Oriented Programming.

But they’re not purely the domain of OOP

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-023.resized.jpg)

Here’s an example. what does a storage device, an input device, and a network socket have in common?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-024.resized.jpg)

Bonus points for whoever can tell me the reference in this picture.

From the Unix perspective, they’re all files.

Everything is a file

Well technically, everything is a file descriptor.

But have you ever wondered how is this possible? How can you have an operating system treating everything as if it’s a file when it's obvious that an ethernet device isn't a file?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-025.resized.jpg)

There are generally five functions you need to implement if you want to write a device driver for a Unix system. There are more, but these five are the most common.

If you implement these (and note that returning nil is an implementation; just take a look at `/dev/null`) then you conform to the file descriptor POSIX API specification.

That also means you get the benefits of getting treated just like every other file.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-026.resized.jpg)

Or, just like what Tyler Durden from fight club says: you are not a beautiful or unique snowflake.

And that’s a good thing!

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-027.resized.jpg)

That means that you can use common tools to operate on different things.

Whether it’s a storage device, a network stream, or the keyboard circular buffer, you can use the common unix tools to operate on them

Even if you don’t care about whether the device responds—just use `/dev/null`

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-028.resized.jpg)

In this case, common tools operating on different things is the principle, polymorphism is the technique.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-029.resized.jpg)

You can also have encapsulation without oop

In fact, you’re using it all the time. when you open your browser and go to google.com you don’t really care about how google retrieved the search results; all you’re interested in is what the search results are.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-030.resized.jpg)

In a sense, your only public interface is that of the search bar.

It represents the big, complicated machinery that is called google search, and presents it as something that can be easily understood.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-031.resized.jpg)

A more code related example: Let’s take a quick look at the calculator brain.

Notice how the Brain class only has a few exposed methods, out of which two are used in react: `display`, `input_char`

Three if you count `new` which creates an object out of the class.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-032.resized.jpg)

Here’s the object that have its methods exposed.

This isn’t the best implementation of a calculator, but that’s okay. Notice that I can easily refactor or rewrite this entirely without severely affecting the UI framework.

Because the UI framework only know about a few very specific api calls, they don’t know a lot about how the brain operates. They are shielded from changes in the brain.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-033.resized.jpg)

That’s because this object has a very small surface area.

Note the distinction here. I didn’t say that the object was small - it really isn't. I said that its surface area is small.

If you've ever encountered God objects in your code (hint: check all files in your code that end with "service") then you know the problem very well. You have a very hard time debugging your application because it's just so big and complex!

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-034.resized.jpg)

Well. You see, the problem isn't that those objects are too big.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-035.resized.jpg)

It’s because God objects are too fat (paraphrasing [Sebastian Markbage](http://2014.jsconf.eu/speakers/sebastian-markbage-minimal-api-surface-area-learning-patterns-instead-of-frameworks.html
)).

When your objects try to expose a lot of methods in its interface, the API surface area of your objects is too wide.

And that makes your app complex and difficult to manage because these APIs will get used, and you need to remember all of these things. You will have to memorize them and keep asking yourself: what connects to where?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-036.resized.jpg)

So the principle here is information hiding, and the technique is encapsulation.

This concept allows you to represent something really big and complex with something small and simple by exposing a small surface api.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-037.resized.jpg)

But yeah, we all know about this already, right? Ruby is OOP, we use OOP all the time!

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-038.resized.jpg)

Here's the thing: If you ask many programmers what OOP is about, they’ll just tell you it’s using objects to do stuff.

They’ll tell you that OOP is about programming with objects. It’s not, that’s just a tautology--saying the same thing twice in different words.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-039.resized.jpg)

So no. It’s not just about programming with objects.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-040.resized.jpg)

It’s a different way of thinking about your code, where you tell an object what you want, instead of just storing and operating on data.

It is a method of organization.

And it’s just one of many.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-041.resized.jpg)

Just like Functional, Prototype-based, Rails-way based, or a combination of these are. They are all ways to organize your program so you can more easily figure out how things are connected.

I think we're doing ourselves a disservice by not going back to basics and experiencing for ourselves a whole new different way of writing our apps.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-042.resized.jpg)

If you want to write cross platform apps, you need to write reusable code.

Unfortunately, the Rails way of writing apps is not enough.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-043.resized.jpg)

That doesn’t mean that the Rails way is “wrong” or that we should stop using it because it “promotes bad habits”
a framework is, after all, just a tool and it is up to the programmer to decide how to use it.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-044.resized.jpg)

DHH famously said that [Rails is Omakase](http://david.heinemeierhansson.com/2012/rails-is-omakase.html), that he is the head chef that decides the experience that is Rails. And this arrangement has been great because Rails is an awesome framework that makes it really easy to make web applications.

And that is where we run into a problem with cross platform support; the Rails way is too web centric that it’s very difficult to reuse prior work for other platforms.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-045.resized.jpg)

Does that mean we should just not use Rails or any other framework at all?

Not at all.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-046.resized.jpg)

This is Kent Beck, he is the founder of Extreme Programming, the precursor to what we now call agile software development, and from where we get the scrum methodology.

One of his papers talked about connected and modular designs, and the Rails way falls quite near to the connected design model.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-047.resized.jpg)

Here’s what [he said](https://gist.github.com/parasquid/efa7a516913769726b32e768f673f31a#design-for-latency
):

> In a connected system, elements are highly available to each other (via global state, for example). Adding the first feature to a connected system is cheap. All the resources you need are available. However, the cost of all those connections is that subsequent features are very likely to interact with previous features, driving up the cost of development over time.

This is one of the reasons why Rails apps can be built so fast. I join hackathons, and I always use Rails because it’s really so easy to just build features because I have access to everything.

It’s one of the reasons why bootcamps and one day tutorials can show people the power of programming—because producing a usable output is so easy.


---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-048.resized.jpg)

Here’s the next thing [he said](https://gist.github.com/parasquid/efa7a516913769726b32e768f673f31a#design-for-latency
):

> A modular design has connections deliberately kept to a minimum. The cost for the first feature is likely to be higher than in the connected system, because you need to find the necessary resources and bring them together, possibly re-modularizing in the process. Features are much less likely to interact in a modular system, though, leading to a steady stream of features at relatively constant cost.

And so we have a problem.

A mature system benefits from a modular design. We know about the [Abstract Singleton Proxy Factory Bean](https://docs.spring.io/spring/docs/2.5.x/javadoc-api/org/springframework/aop/framework/AbstractSingletonProxyFactoryBean.html) jokes in java, but the reason why there’s a lot of code monkeys in enterprise application development is because the modular design allows easy distribution of work.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-049.resized.jpg)

The issue is that it’s so costly to start modular, because there's a lot of code and thought investment needed.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-050.resized.jpg)

The advice then, is not to ditch connected designs. Kent Beck recommends to stay on the connected curve until the climb phase, then switch to the modular curve.

How do you know when the climb phase begins? That’s when experience comes in.

How would you even know what to switch to if you’re not familiar with how modular designs look like?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-051.resized.jpg)

We need to find that knowledge to organize your code as if it was a USB cable.

That would be really cool.

If you wanted to swap the UI, all you needed to do is to write the UI layer for that framework.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-052.resized.jpg)

It would look something like this

[request-response] Rails -- App

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-053.resized.jpg)

[streaming] Telnet/Websockets -- App

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-054.resized.jpg)

[mobile] RubyMotion -- App

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-055.resized.jpg)

[browser] Opal -- App

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-056.resized.jpg)

[hardware] mRuby -- App

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-057.resized.jpg)

The rails way is what we're familiar with.

Many of us started learning ruby because of rails. I got reintroduced to ruby because Mindvalley uses rails.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-058.resized.jpg)

But my point is, that it’s not the only code-organization technique out there.

And we haven’t been seeking them out.

Have you tried any of these? Have you tried to at least deviate a little bit from the Rails way?

Here you have a command-query separation by Bertrand Meyer, here you have event sourcing which says that all changes to an application state should be stored as a sequence of events, and here we have the DCI paradigm which builds on top of OOP.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-059.resized.jpg)

Our industry is still young, but is now mature enough to recognize that there are many different ways to skin a cat.

These are just a few presentations tackling a different face of the same issue: we are too web centric because the Rails way makes it easy to write web applications

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-060.resized.jpg)

Tightly coupling with the rails framework works great if you want to create apps that are similar to Basecamp, you’re targeting web only, and you know that's the final iteration of your product.

But sometimes, your app is far out different from basecamp.

If you are planning to reuse a significant portion of your code across platforms, the rails way is not enough. But more importantly, it’s not the only organizational technique available to you.

I think that as programmers, we need to start looking beyond what we’re comfortable with, and start rediscovering solutions to problems that have been solved by other disciplines.

But if you had only one idea to take home with you, let it be this: that programming is fundamentally an activity by humans, for humans.

Many people think that programming equals coding, and that’s really disappointing. That’s just scratching the surface, because programming is more than that.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-065.resized.jpg)

Programming is the act of managing complexity.

We often make the mistake of thinking that we're programming for the computer. No, your computer won't run your program faster solely because you used a well designed architecture.

But YOU will be faster, because your wonderful but still limited brain can now comprehend the relationships in the code.

By organizing our code and designing it so it’s easy to understand, we free our brains and give it space to think about the stuff that really matters: what is your app supposed to do?

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-066.resized.jpg)

When you start focusing on that question, and start expanding your toolbox, you end up with more flexible, maintainable, and reusable code.

And that’s it. That’s the answer. That's how you write cross platform apps.

---

![Life Beyond Rails](https://s3-ap-southeast-1.amazonaws.com/hackworkplay-assets/rubyconfkl2016-page-067.resized.jpg)

I'm Tristan, and I'm the Chief Problem Solver at Mindvalley. You can find me on facebook and github @parasquid

Thank you

Slideshare link: <http://www.slideshare.net/parasquid/life-beyond-rails-creating-cross-platform-ruby-apps>
