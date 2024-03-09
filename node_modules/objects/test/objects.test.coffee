should  = require "should"
objects = require "../lib/objects"

describe "#merge", ->
  it "should merge shallow objects", ->
    a = a: 1, b: 2, c: 3
    b = d: 4
    c = objects.merge a, b
    should.exist c
    c.should.eql a: 1, b: 2, c: 3, d: 4

  it "should merge deep objects", ->
    a = a:1, b: {b1a: 2, b1b: {b2: 4}}, c: 3
    b = d: 4, b: e: 7
    c = objects.merge a, b
    should.exist c
    c.should.eql a: 1,b: {b1a: 2, b1b: {b2: 4}, e: 7}, c: 3, d: 4 

describe "#type", ->
  it "should be 'string' for string", ->
    objects.type("anton").should.eql "string"  
  it "should be 'number' for number", ->
    objects.type(87).should.eql "number"     
  it "should be 'array' for array", ->
    objects.type(["anton", "andrew"]).should.eql "array"   
  it "should be 'object' for object", ->
    objects.type({name: "Anton", country: "Ukraine"}).should.eql "object"  
  it "should be 'boolean' for boolean", ->
    objects.type(false).should.eql "boolean"   
  it "should be 'function' for function", ->
    objects.type(->).should.eql "function"                        

describe "#diff", ->
  it "should find array of differences", ->
    obj1 = 
      name: "Anton"
      age: 24
    obj2 =
      name: "Anton"
      age: 25
    diffs = objects.diff obj1, obj2    
    diffs.should.have.lengthOf 1
    diffs[0].property.should.eql "age"
    diffs[0].oldValue.should.eql 24
    diffs[0].newValue.should.eql 25
  it "should return emty array for the same objetcs", ->
    obj1 = 
      name: "Anton"
      age: 24
    obj2 =
      name: "Anton"
      age: 24
    diffs = objects.diff obj1, obj2    
    diffs.should.have.lengthOf 0

describe "#subtract", ->
  it "should find example differences", ->
    a = 
      aa: 2
      ab: {a:1, c:3}
    b = 
      aa: 1
      ab: {a:1, b:2, c:3}
    d = objects.subtract a, b
    objects.type(d.added).should.eql "object"
    Object.keys(d.added).length.should.eql 0
    d.changed.aa.should.eql 2
    d.removed.ab.b.should.eql 2
    d.numChanged.add.should.eql 0
    d.numChanged.modify.should.eql 1
    d.numChanged.removed.should.eql 1
    d.numChanged.total.should.eql 2
  it "should detect changes to undefined values as modifications not additions/deletions", ->
    a = 
      aa: {aaa: 1, aab: undefined}
      ab: 2
      ac: 3
    b = 
      aa: undefined
    d = objects.subtract a, b
    console.log "\n\n\n=-=-=[subtract](a-b)", d, "\n\n\n"
    d.added.ab.should.eql 2
    d.added.ac.should.eql 3
    d.changed.aa.aaa.should.eql 1
  it "should not violate the equality principal: if A-B=C then A-C=B", ->
    a = 
      aa: {aaa: 1, aab: undefined}
      ab: 2
      ac: 3
    b = 
      aa: undefined
    e = objects.subtract b, a
    console.log "\n\n\n=-=-=[subtract](b-a)", e, "\n\n\n"
    e.changed.hasOwnProperty("aa").should.eql true
    should.equal e.changed.aa? false
    e.removed.ab.should.eql 2
    e.removed.ac.should.eql 3




