React = {createElement: e, createFactory} = require "react"
{ Router, hashHistory } = require "react-router"
{ render } = require "react-dom"
{R, index, child} = require "../"

_makeComponent = (msg) -> ({foo, children}) ->
  e 'div', {},
    e 'h2', {}, msg
    children

App = _makeComponent "App"
Landing = _makeComponent "welcome!"
About = _makeComponent "about"
AboutMain = _makeComponent "about main"
AboutFoo = _makeComponent "about foo"
AboutBar = _makeComponent "about bar"

routes = R "/", App,
  index Landing
  child R "welcome", Landing
  child R "about", About,
    index AboutMain
    child R "foo", AboutFoo
    child R "bar", AboutBar

console.info "routes:", routes

Main = (createFactory Router) {history: hashHistory, routes}

render Main, document.getElementById "root"
