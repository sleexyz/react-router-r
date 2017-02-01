{R, child, dynamic, index} = require './'
{assert} = require 'chai'
{createElement: e} = require 'react'

Component0 = (props) -> e 'div', props.children
Component1 = () -> e 'div', {}
Component2 = () -> e 'div', {}
Component3 = () -> e 'div', {}
Component4 = () -> e 'div', {}

describe 'R', ->
  it 'adds path', ->
    routeObj = R '/', Component0
    assert.equal routeObj.path, '/'

  it 'adds component', ->
    routeObj = R '/', Component0
    assert.equal routeObj.component, Component0

describe 'child', ->
  it 'works when used once', ->
    routeObj = R '/', Component0,
      child R '', Component1
    assert.isArray routeObj.childRoutes
    assert routeObj.childRoutes.length is 1
    assert.deepEqual routeObj.childRoutes[0], R '', Component1

  it 'works when used multiple times', ->
    routeObj = R '/', Component0,
      child R 'foo', Component1
      child R 'bar', Component2
      child R 'baz', Component3

    assert.isArray routeObj.childRoutes
    assert routeObj.childRoutes.length is 3
    assert.deepEqual routeObj.childRoutes[0], R 'foo', Component1
    assert.deepEqual routeObj.childRoutes[1], R 'bar', Component2
    assert.deepEqual routeObj.childRoutes[2], R 'baz', Component3

describe 'index', ->
  it 'works when used once', ->
    routeObj = R '/', Component0,
      index Component1
    assert.equal routeObj.indexRoute.component, Component1

  it 'throws an error when used more than once', ->
    makeRouteObj = ->
      R '/', Component0,
        index Component1
        index Component2
    assert.throws makeRouteObj, Error

describe 'dynamic', ->
  it 'adds a route to childRoutes', ->
    routeObj = R '/', Component0,
      child R 'foo', Component1
      dynamic path: 'bar', component: Component1, getRouteAsync: (callback) ->
        callback R '', Component2,
          index Component3
      child R 'baz', Component1
    assert.equal routeObj.childRoutes.length, 3

  it 'adds path, component, getIndexRoute and getChildRoutes', ->
    routeObj = R '/', Component0,
      child R 'foo', Component1
      dynamic path: 'bar', component: Component1, getRouteAsync: (callback) ->
        callback R '', Component2,
          index Component3
      child R 'baz', Component1
    assert.equal routeObj.childRoutes[1].component, Component1
    assert.equal routeObj.childRoutes[1].path, 'bar'
    assert.isFunction routeObj.childRoutes[1].getIndexRoute
    assert.isFunction routeObj.childRoutes[1].getChildRoutes

  it 'omits path and component when they are ommited', ->
    routeObj = R '/', Component0,
      child R 'foo', Component1
      dynamic getRouteAsync: (callback) ->
        callback R '', Component2,
          index Component3
      child R 'baz', Component1
    assert.isNotOk 'component' of routeObj.childRoutes[1]
    assert.isNotOk 'path' of routeObj.childRoutes[1]

  it 'returns dynamic inner component when its indexRoute is not provided', ->
    routeObj = R '/', Component0,
      child R 'foo', Component1
      dynamic path: 'bar', component: Component1, getRouteAsync: (callback) ->
        callback R '', Component2,
          child R 'hello', Component3
          child R 'world', Component3
      child R 'baz', Component1
    dynamicError = undefined
    dynamicIndex = undefined
    routeObj.childRoutes[1].getIndexRoute null, (err, indexRoute) ->
      dynamicError = err
      dynamicIndex = indexRoute
    assert.isUndefined  dynamicError
    assert.equal dynamicIndex.component, Component2

  it 'returns nothing when neither dynamic inner route nor its indexRoute is provided', ->
    routeObj = R '/', Component0,
      child R 'foo', Component1
      dynamic path: 'bar', component: Component1, getRouteAsync: (callback) ->
        callback R '', undefined,
          child R 'hello', Component3
          child R 'world', Component3
      child R 'baz', Component1
    dynamicError = undefined
    dynamicIndex = undefined
    routeObj.childRoutes[1].getIndexRoute null, (err, indexRoute) ->
      dynamicError = err
      dynamicIndex = indexRoute
    assert.isUndefined  dynamicError
    assert.isNull dynamicIndex.component

  it 'always dynamically returns one child route', ->
    routeObj = R '/', Component0,
      child R 'foo', Component1
      dynamic path: 'bar', component: Component1, getRouteAsync: (callback) ->
        callback R '', Component2,
          index Component3
      child R 'baz', Component1
    dynamicError = undefined
    dynamicChildRoutes = undefined
    routeObj.childRoutes[1].getChildRoutes null, (err, childRoutes) ->
      dynamicError = err
      dynamicChildRoutes = childRoutes
    assert.isUndefined dynamicError
    assert.isArray dynamicChildRoutes
    assert.equal dynamicChildRoutes.length, 1

describe '(together)', ->
  it 'works', ->
    routeObj1 = R '/', Component0,
      index Component1
      child R 'foo', Component1
      child R 'bar', Component2
      child R 'baz', Component3

    routeObj2 = R '/', Component0,
      child R 'foo', Component1
      child R 'bar', Component2
      child R 'baz', Component3
      index Component1

    assert.deepEqual routeObj1, routeObj2

  it 'preserves route order', ->
    routeObj1 = R '/', Component0,
      index Component1
      child R 'foo', Component1
      child R 'bar', Component2
      child R 'baz', Component3

    routeObj2 = R '/', Component0,
      child R 'baz', Component3
      child R 'bar', Component2
      child R 'foo', Component1
      index Component1

    assert.notDeepEqual routeObj1, routeObj2
