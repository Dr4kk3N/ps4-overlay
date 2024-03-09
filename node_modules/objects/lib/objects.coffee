_          = require "underscore"
_s         = require "underscore.string"
objectDiff = require "objectdiff"


classToType = {}
for name in "Boolean Number String Function Array Date RegExp".split(" ")
  classToType["[object " + name + "]"] = name.toLowerCase()

exports.type = (obj) ->
  if obj == undefined or obj == null
    return String obj
  myClass = Object.prototype.toString.call obj
  if myClass of classToType
    return classToType[myClass]
  return "object"

# Merge two array into one.
exports.mergeArrays = (first, second) -> Array::push.apply first, second

# Get only plain properties from object and skip nested objects.
exports.plainProperties = (object) ->
  if !object or !_.isObject(object)
    return {}
  attributes = {}
  for attribute, value of object when not _.isObject(value)
    attributes[attribute] = value
  return attributes  

# Removes all functions from keys (deep search)
# -- Cannot handle circlar references
# -- Implemented by scrubbing through JSON parser
exports.onlyData = (object) =>
  intermediateObject = JSON.stringify object
  return JSON.parse intermediateObject

# Object Subtraction -- The list of changes (change log) in moving from Object B to Object A
#     Implements: (return value) = objectA - objectB; e.g. objectA = merge(ObjectB, ObjectC) 
#     -- Array property handling is present, but weak at the moment. 
#     -- Deep (recursive) implementation; avoid circular references.
#     -- Does not handle function properties.
exports.subtract = (objectA, _objectB) =>
  objectB = @clone _objectB
  objectAdd = {}
  objectModify = {}
  numChanges = _subtract(objectA, objectB, objectAdd, objectModify)
  return {
    added: objectAdd
    changed: objectModify
    removed: objectB
    numChanged: numChanges
  }

# Helper function
# -- returns number of changes found
# -- A = new one; B = original one; e.g. A - B
# -- forceModify: when true, will write missing-in-B as a modify rather than add operation -- for handling undefined objects: a={a:undefined}; b={a:{b:1}}
_subtract = (objectA, objectB, objectAdd, objectModify, forceModify) =>
  numChanges = {
    add: 0
    modify: 0
    removed: 0
    total: 0
  }
  # [FOR A] -- iterate over the properties of A (find added and modified)
  for attribute, value of objectA
    if objectB? and objectB.hasOwnProperty attribute
      #both A and B has this attribute defined
      switch @type value
        when "object"
          #need to recursive compare (deep analysis)
          objectAdd[attribute] = {} #enable recursion
          objectModify[attribute] = {}          
          numChangesInObject = _subtract objectA[attribute], objectB[attribute], objectAdd[attribute], objectModify[attribute], not objectB[attribute]?
          #accumulate changes
          numChanges[counter] += numChangesInObject[counter] for counter of numChanges
          #cleanup -- don't report when nothing changed
          delete objectB[attribute] if numChangesInObject.removed is 0
          delete objectAdd[attribute] if numChangesInObject.add is 0
          delete objectModify[attribute] if numChangesInObject.modify is 0
        when "function"
          #ignore this, we don't support function comparison
          console.log "WARNING: Function attributes not supported."
          delete objectB[attribute]     
        when "array"          
          if _.difference(value, objectB[attribute]).length isnt 0
            # [MODIFIED] -- value was changed
            #TODO, implement better array comparison: need to check ordering, deal with element-by-element changes
            objectModify[attribute] = value
            numChanges.modify++
          delete objectB[attribute]  # This doesn't allow for support of Arrays-of-Objects; TODO: add support
        else
          # rely on javascript comparisons for everything else
          if value isnt objectB[attribute]
            # [MODIFIED] -- value was changed
            objectModify[attribute] = value
            numChanges.modify++ 
          delete objectB[attribute]     
    else
      if forceModify
        # [MODIFY] -- handle undefined objects: a={a:undefined}; b={a:{b:1}}
        objectModify[attribute] = value
        numChanges.modify++        
      else
        # [ADDED] -- new attribute was added (In A, but not in B)
        objectAdd[attribute] = value
        numChanges.add++
  # [FOR B] -- iterate over the properties of B (find removed)
  for attribute, value of objectB
    if not objectA.hasOwnProperty attribute
      # [DELETED] -- attribute was removed
      numChanges.removed++
  # [TOTAL] -- add it up and report it back! =)
  numChanges.total = numChanges.add + numChanges.modify + numChanges.removed 
  return numChanges

# Find differences between two objects.
exports.diff = (object1, object2) ->
  changes = objectDiff.diff object1, object2    
  diffs = []
  for changeName, change of changes when change.changed != "equals" and changeName != "id"
    diff = 
      property: changeName
      oldValue: change.removed
      newValue: change.added
    diffs.push diff
  return diffs

#  Deep object extension (merge).
#  Usage: mergedObject = objects.merge(grandparent, child, grandchild, greatgrandchild)
#    1. Priority of objects is right-to-left; first param is overwritten by second param, etc...
#    2. Based conceptually on the _.extend() function in underscore.js ( http://documentcloud.github.com/underscore/#extend )
#    3. From deepExtend gist by author: Kurt Milam - http://xioup.com
#    4. https://gist.github.com/1868955 
exports.merge = (obj) ->
  parentRE = /#{\s*?_\s*?}/
  slice = Array.prototype.slice
  hasOwnProperty = Object.prototype.hasOwnProperty

  _.each slice.call(arguments, 1), (source) =>
    for prop of source
      if hasOwnProperty.call source, prop
        if _.isUndefined obj[prop]
          obj[prop] = source[prop]        
        else if _.isString(source[prop]) and parentRE.test(source[prop])
          if _.isString obj[prop]
            obj[prop] = source[prop].replace(parentRE, obj[prop])        
        else if _.isArray(obj[prop]) or _.isArray(source[prop])
          if (not _.isArray(obj[prop])) or (not _.isArray(source[prop]))
            throw "Error: Trying to combine an array with a non-array (" + prop + ")"
          else 
            obj[prop] = _.reject @merge(obj[prop], source[prop]), (item) -> 
              return _.isNull(item)        
        else if _.isObject(obj[prop]) or _.isObject(source[prop])
          if (not _.isObject(obj[prop])) or (not _.isObject(source[prop]))
            throw "Error: Trying to combine an object with a non-object (" + prop + ")"
          else 
            obj[prop] = @merge obj[prop], source[prop]
        else
          obj[prop] = source[prop]
  
  return obj

# Deep clone
exports.clone = (obj) ->
  if not obj? or typeof obj isnt 'object'
    return obj

  if obj instanceof Date
    return new Date(obj.getTime()) 

  if obj instanceof RegExp
    flags = ''
    flags += 'g' if obj.global?
    flags += 'i' if obj.ignoreCase?
    flags += 'm' if obj.multiline?
    flags += 'y' if obj.sticky?
    return new RegExp(obj.source, flags) 

  newInstance = new obj.constructor()

  for key of obj
    newInstance[key] = @clone obj[key]

  return newInstance

#   Find a specific object in an array of objects where a specific property equals a specific value.
#     Returns undefined if not found.
#   Usage: theContainedObject = objects.find(myArray, "id", 4)
#   Notes: 
#       1. Pass by reference - objects are reference in, reference out (deep copy, see clone(..), the return value if so desired)
#       2. Short circuit analysis - returns only the first object found in array index ascending order 
exports.find = (array, property, value) ->
  for i in [0...array.length]
    if (array[i][property] == value)
      return array[i]
  return undefined
  
#   Find a specific object in an array of objects where a specific property equals a specific value.
#     Returns undefined if not found. Returns the index of the location otherwise.
#   Usage: theContainedObject = objects.findIndex(myArray, "id", 4)
#   Notes: 
#       1. Pass by reference - objects are reference in, reference out (deep copy, see clone(..), the return value if so desired)
#       2. Short circuit analysis - returns only the first object found in array index ascending order 
exports.findIndex = (array, property, value) ->
  for i in [0...array.length]
    if (array[i][property] == value)
      return i
  return undefined

#   Add a prefix to the name of all properties of an Object. Useful for avoiding collisions when merging/extending objects.
#   Follows lowerCamel convention
exports.prefix = (theObject, prefix) ->
  newObject = {}
  for eachProperty of theObject
    if eachProperty is "id"
      newObject[prefix + "ID"] = theObject["id"]
    else
      newObject[prefix + _s.capitalize eachProperty] = theObject[eachProperty]
  return newObject

#   Pretty print an object to disk. Useful for deep visualization/inspection during development/test.
exports.write = (theObject, filename) ->
  fs.writeFileSync filename, JSON.stringify theObject, undefined, "\t"

###
  Object to JSON string
  -- Handles error objects that get mangled by JSON.stringify
###
exports.stringify = (theObject) ->
  numKeys = 0
  str = "{"
  for key, value of theObject
    numKeys++
    str += "\"#{key}\":\"#{value}\","
  str = str[0...str.length-1] if numKeys > 0
  str += "}"
  return str
