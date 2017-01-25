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

R.child = (childRoute) -> (route) ->
  route.childRoutes = [] unless Array.isArray route.childRoutes
  route.childRoutes.push childRoute
  route

R.index = (component) -> (route) ->
  ensureNotIn 'indexRoute', route, 'index can only be used once'
  route.indexRoute = {component}
  route

Contain = (parent, child) -> (props) -> createElement parent, {}, createElement child, {}

R.dynamic = (path, component, getRouteAsync) ->
  path: path
  component: component
  getIndexRoute: (_partialNextState, callback) ->
    getRouteAsync (component, transformers...) ->
      route = R path, component, transformers...
      callback null,
        component: Contain route.component, route.indexRoute.component
  getChildRoutes: (_partialNextState, callback) ->
    getRouteAsync (component, transformers...) ->
      route = R '', component, transformers...
      callback null, [route]

module.exports = R
