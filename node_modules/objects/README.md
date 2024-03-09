node-objects
==========

Simple objects' utilities for Node.js

# Overview

Simple utility libraries that have common methods to deal with objects.

## Use

Install

`npm install objects`


Code

```coffeescript
objects = require "objects"
```

That's easy!

# The Library

## type (type of variable)

Report the type of the variable safely as a string. 

Possible return values:

* ```undefined```, ```null```
* ```boolean```, ```number```, ```string```, ```function```, ```array```, ```date```, ```regexp```
* ```object```

```coffeescript
exports.type = (obj) ->
```

## mergeArrays

Merge two array into one.

```
exports.mergeArrays = (first, second) -> Array::push.apply first, second
```

## plainProperties

Get only plain properties from object and skip nested objects.

```
exports.plainProperties = (object) ->
```

## onlyData

Removes all functions (and other non-JSON-safe types) from keys (deep search)

* Cannot handle circlar references
* Internal deep clone (returns a new object, non-destructive to original)

```
exports.onlyData = (object) =>
```

## diff (object difference, see subtract for changelog)

* Find differences between two objects.

```coffeescript
exports.diff = (object1, object2) ->
```

## subtract (Change Log)

* Find and characterize the differences between two objects
* Report polarity is oriented such that A = new state and B = prior state (e.g. A - B) 
* Report identifies the changes that need to be applied to the prior state (B) to reach the new state (A)
* A-B=C --> B+C=A; A = new state, B = prior state, C = results from subtract(A,B) 

```coffeescript
  a = {
    aa: 2
    ab: {a:1, c:3}
  }
  b = {
    aa: 1
    ab: {a:1, b:2, c:3}
  }
  objects.subtract a, b
```

results in a return object of:

```coffeescript
{
    added: {}
    changed: { aa: 2 }
    removed: { ab: { b: 2 } }
    numChanged: 
      {
        add: 0
        modify: 1
        removed: 1
        total: 2
      }
}
```

## merge (deep extend)

Deep object extension (merge).

* Priority of objects is right-to-left; first param is overwritten by second param, etc...
* Based conceptually on the _.extend() function in underscore.js ( http://documentcloud.github.com/underscore/#extend )
* From deepExtend gist by author: Kurt Milam - http://xioup.com
* https://gist.github.com/1868955 

```coffeescript
mergedObject = objects.merge(grandparent, child, grandchild, greatgrandchild)
```

## clone (deep copy)

Deep clone

```coffeescript
exports.clone = (obj) ->
```

## find

Find a specific object in an array of objects where a specific property equals a specific value.

* Returns undefined if not found.
* Pass by reference - objects are reference in, reference out (deep copy, see clone(..), the return value if so desired)
* Short circuit analysis - returns only the first object found in array index ascending order 

Usage: theContainedObject = objects.find(myArray, "id", 4)

```coffeescript
exports.find = (array, property, value) ->
```

## findIndex

Find a specific object in an array of objects where a specific property equals a specific value.

* Returns undefined if not found. Returns the index of the location otherwise.
* Pass by reference - objects are reference in, reference out (deep copy, see clone(..), the return value if so desired)
* Short circuit analysis - returns only the first object found in array index ascending order 
       
Usage: theContainedObject = objects.findIndex(myArray, "id", 4)

```coffeescript
exports.findIndex = (array, property, value) ->
```

## prefix

Add a prefix to the name of all properties of an Object. 

* Useful for avoiding collisions when merging/extending objects. 
* Follows lowerCamel convention

```coffeescript
exports.prefix = (theObject, prefix) ->
```

## write

Pretty print an object to disk. 

* Useful for deep visualization/inspection during development/test.

```coffeescript
exports.write = (theObject, filename) ->
  fs.writeFileSync filename, JSON.stringify theObject, undefined, "\t"
```

## stringify

Object to JSON string

* Handles error objects that get mangled by JSON.stringify

```coffeescript
exports.stringify = (theObject) ->
```

# Contributions

If you need any feature tell us or fork project and implement it by yourself.

We appreciate feedback!

## License

(The MIT License)

Copyright (c) 2011 CircuitHub., https://circuithub.com/

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
