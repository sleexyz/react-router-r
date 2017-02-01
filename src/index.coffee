{createElement} = require 'react'

ensureNotIn = (field, obj, msg) ->
  if field of obj
    error = new Error "#{msg}. Found #{field} in route"
    error.framesToPop = 1
    throw error

R = (path, component, transformers...) ->
  route = {path, component}
  for transformer in transformers
    route = transformer route
  route

child = (childRoute) -> (route) ->
  route.childRoutes = [] unless Array.isArray route.childRoutes
  route.childRoutes.push childRoute
  route

index = (component) -> (route) ->
  ensureNotIn 'indexRoute', route, 'index can only be used once'
  route.indexRoute = {component}
  route

_Contain = (parent, child) ->
  (props) -> createElement parent, {}, createElement child, {}

dynamic = ({path, component, getRouteAsync}) -> (route) ->
  throw new Error 'getRouteAsync not provided' unless getRouteAsync?
  childRoute = {}
  if path? then childRoute.path = path
  if component? then childRoute.component = component
  childRoute.getIndexRoute = (_partialNextState, callback) ->
    getRouteAsync (route) ->
      if route.indexRoute?
        if route.component?
          callback undefined,
            component: _Contain route.component, route.indexRoute.component
        else
          callback undefined,
            component: route.indexRoute.component
      else
        if route.component?
          callback undefined,
            component: route.component
        else
          callback undefined,
            component: null
  childRoute.getChildRoutes = (_partialNextState, callback) ->
    getRouteAsync (route) ->
      callback undefined, [route]
  child(childRoute) route

module.exports = {R, child, dynamic, index}
