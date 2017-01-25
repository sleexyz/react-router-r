React = {createElement: e, createFactory} = require "react"
{Router, hashHistory} = require "react-router"
{render} = require "react-dom"
R = {index, child, dynamic} = require "../"

_makeComponent = (msg) -> ({foo, children}) ->
  e 'div', {},
    e 'h2', {}, msg
    children

App = _makeComponent "App"
Landing = _makeComponent "Landing"
AboutOuter = _makeComponent "AboutOuter"
AboutInner = _makeComponent "AboutInner"
AboutMain = _makeComponent "AboutMain"
AboutFoo = _makeComponent "AboutFoo"
AboutBar = _makeComponent "AboutBar"
Foo = _makeComponent "Foo"
Bar = _makeComponent "Bar"
Baz = _makeComponent "Baz"

routes = R '/', App,
  index Landing
  child R 'welcome', Landing
  dynamic 'about', AboutOuter, (callback) ->
    console.info 'async'
    callback R '', AboutInner,
      index AboutMain
      child R 'foo', AboutFoo
      child R 'bar', AboutBar
  child R 'foo', Foo
  child R 'bar', Bar
  child R 'baz', Baz

console.info "routes:", routes

Main = (createFactory Router) {history: hashHistory, routes}

render Main, document.getElementById "root"
