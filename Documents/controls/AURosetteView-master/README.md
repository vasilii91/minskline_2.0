AURosetteView
==============

AURosetteView is a easy-to-use, clean and lightweight share button primary for social platforms. It looks like rosette with nice animation.

![Screenshot1](https://lh4.googleusercontent.com/-P8SoLgIi-O0/T-SY8fqy4nI/AAAAAAAABro/0Q0gRUh43BQ/s206/Zrzut%2520ekranu%25202012-06-22%2520o%252015.25.20.png)

Build the included Sample app to see it in action.

Requirements
------------

Requires iPhone OS SDK 3.0 or greater. 

Using AURosetteView in Your Project
=====================================

To use AURosetteView copy the source code into your project then add a data source class for your photos.  Here is how:

1. Add sub module in your project: `git submodule add http://github.com/appunite/AURosetteView.git` Frameworks/AURosetteView
2. open Frameworks/AURosetteView
3. Copy AURosetteView.xcodeproj to your project Frameworks group.
4. Go to your project -> select correct target -> build phases
5. Add AURosetteViewLib to your Target Dependences
6. Add libAURosetteViewLib.a, QuartzCore, CoreImage and CoreGraphics to your Link Binary With Libraries
7. Include <AURosetteView/AURosetteItem.h>
8. Include <AURosetteView/AURosetteView.h>
9. Create objects of AURosetteItem
10. Create a view of AURosetteView with AURosetteItems using initWithItems
11. Add AURosetteView on your view
12. Implement selectors

Status
======

The project is a work in progress. 

TO DO
-----
* Button highlight
* Setting properties of buttons like colors and so on

License
===

The MIT License (MIT)
Copyright (c) 2013

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

