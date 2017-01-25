R = {child, index} = require './'
{assert} = require 'chai'
{createElement: e} = require 'react'

Component0 = (props) -> e 'div', props.children
Component1 = () -> e 'div', {}
Component2 = () -> e 'div', {}
Component3 = () -> e 'div', {}

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
  it 'adds getIndexRoute and getChildRoutes', ->
    routeObj = R.dynamic '/', Component0, (callback) ->
      callback R '', Component1,
        child R 'foo', Component1
        child R 'bar', Component2
        child R 'baz', Component3
      assert.isFunction routeObj.getIndexRoute
      assert.isFunction routeObj.getChildRoutes

  it 'returns error when indexRoute is not provided', ->
    routeObj = R.dynamic '/', Component0, (callback) ->
      callback R '', Component1,
        child R 'foo', Component1
    dynamicError = undefined
    dynamicIndex = undefined
    routeObj.getIndexRoute null, (err, indexRoute) ->
      dynamicError = err
      dynamicIndex = indexRoute
    assert dynamicError, 'error not provided'
    assert.isUndefined dynamicIndex

  it 'gracefully returns no dynamic child routes when not provided', ->
    routeObj = R.dynamic '/', Component0, (callback) ->
      callback R '', Component1,
        index Component2
    dynamicError = undefined
    dynamicChildRoutes = undefined
    routeObj.getChildRoutes null, (err, childRoutes) ->
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
