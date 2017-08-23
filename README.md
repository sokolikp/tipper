# Pre-work - *Tipper*

**Tipper** is a tip calculator application for iOS.

Submitted by: **Paul Sokolik**

Time spent: **7** hours spent in total

## User Stories

The following **required** functionality is complete:

* [X] User can enter a bill amount, choose a tip percentage, and see the tip and total values.
* [X] Settings page to change the default tip percentage.

The following **optional** features are implemented:
* [X] UI animations
* [X] Remembering the bill amount across app restarts (if <10mins)
* [X] Using locale-specific currency and currency thousands separators.
* [X] Making sure the keyboard is always visible and the bill amount is always the first responder. This way the user doesn't have to tap anywhere to use this app. Just launch the app and start typing.

The following **additional** features are implemented:

- [X] Update default tip segments

## Video Walkthrough 

Here's a walkthrough of implemented user stories:

<img src='http://i.imgur.com/WsTMCB8.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />


GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Project Analysis

**Question 1**: "What are your reactions to the iOS app development platform so far? How would you describe outlets and actions to another developer? Bonus: any idea how they are being implemented under the hood? (It might give you some ideas if you right-click on the Storyboard and click Open As->Source Code")

**Answer:** I've been liking Swift/iOS development so far. The drag-and-drop setup in XCode is kind of nice; it's odd not as painful to arrange elements as it is in typical front end development, but I can see the absolute positioning creating difficulties when developing for different device sizes. The view controller lifecycle reminds me slightly of React. It's easy to hook into lifecycle events to update views as needed. 

Outlets and actions are basically ways to tie a UI element to a variable or function in your view controller. For instance, when I create a text field (input box), I can bind the value to a variable and use it throughout my controller (outlet). Similarly, I can bind UI events to functions in my controller so the function gets executed every time the event is triggered (action). It's the same way one binds events/variables between templates and controllers in Angular (or components in React). The entire storyboard is basically an HTML template that is created as you drag-and-drop and set up outlets/actions. When an outlet/action is setup, a `connection` tag is auto-generated within the reference element, and the connections contains outlets and/or actions. Swift probably searches for connection tags on an element when it is manipulated.

**Question 2**: "Swift uses [Automatic Reference Counting](https://developer.apple.com/library/content/documentation/Swift/Conceptual/Swift_Programming_Language/AutomaticReferenceCounting.html#//apple_ref/doc/uid/TP40014097-CH20-ID49) (ARC), which is not a garbage collector, to manage memory. Can you explain how you can get a strong reference cycle for closures? (There's a section explaining this concept in the link, how would you summarize as simply as possible?)"

**Answer:** It's first helfpul to understand that in Swift, strong reference cycles can be formed between class instances when you create a class instance with a property that references another class instance. For example, a strong reference cycle could be created between Book and Author instances (author points to a book and vice versa). These are bad in Swift because ARC won't deinitialize any variables in memory that have strong references, so if you have enough of these instances you'll create memory problems.

A strong reference cycle for closures is the same idea, but between closures and class instances. A class instance could contain a closure/function that executes some code (and therefore have a strong reference to the closure), and that closure could reference the instance via `self`. When that happens, ARC won't deinitialize the objects, even when one is set to nil.

Strong reference cycles can be prevented in Swift by using `weak` and `unowned` keywords to control what types of references are created. In strong cycle references for closures, `weak` and `unowned` keywords are used when defining a capture list to control the references.

## License

    Copyright [2017] [Paul Sokolik]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
