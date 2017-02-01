React = {createElement: e, createFactory} = require "react"
{Router, hashHistory} = require "react-router"
{render} = require "react-dom"
{R, child, dynamic, index} = require "../"

_makeComponent = (msg) -> ({foo, children}) ->
  e 'div', {},
    e 'h2', {}, msg
    children

App = _makeComponent "App"
Landing = _makeComponent "Landing"
AsyncOuter = _makeComponent "AsyncOuter"
AsyncInner = _makeComponent "AsyncInner"
AsyncMain = _makeComponent "AsyncMain"
AsyncFoo = _makeComponent "AsyncFoo"
AsyncBar = _makeComponent "AsyncBar"
AsyncBaz = _makeComponent "AsyncBaz"
Foo = _makeComponent "Foo"
Bar = _makeComponent "Bar"
Baz = _makeComponent "Baz"

routes = R '/', App,
  index Landing
  child R 'landing', Landing

  dynamic path: 'async1', component: AsyncOuter, getRouteAsync: (callback) ->
    console.info 'async1'
    callback R '', AsyncInner,
      index AsyncMain
      child R 'foo', AsyncFoo
      child R 'bar', AsyncBar

  # No index route
  dynamic path: 'async2', component: AsyncOuter, getRouteAsync: (callback) ->
    console.info 'async2'
    callback R '', AsyncInner,
      child R 'foo', AsyncFoo
      child R 'bar', AsyncBar

  # No inner component
  dynamic path: 'async3', component: AsyncOuter, getRouteAsync: (callback) ->
    console.info 'async3'
    callback R '', undefined,
      index AsyncMain
      child R 'foo', AsyncFoo
      child R 'bar', AsyncBar

  # No outer component
  dynamic path: 'async4', getRouteAsync: (callback) ->
    console.info 'async4'
    callback R '', AsyncInner,
      child R 'foo', AsyncFoo
      child R 'bar', AsyncBar

  # No outer component, no inner component, no index route
  dynamic path: 'async5', getRouteAsync: (callback) ->
    console.info 'async5'
    callback R '', undefined,
      child R 'foo', AsyncFoo
      child R 'bar', AsyncBar

  child R 'foo', Foo
  child R 'bar', Bar

  # No outer component, no inner component, no indexRoute, no path
  dynamic getRouteAsync: (callback) ->
    console.info 'async6'
    callback R '', undefined,
      child R 'foo', AsyncFoo # unreachable
      child R 'bar', AsyncBar # unreachable
      child R 'baz', AsyncBaz

  child R 'baz', Baz # unreachable

console.info "routes:", routes

Main = (createFactory Router) {history: hashHistory, routes}

render Main, document.getElementById "root"
