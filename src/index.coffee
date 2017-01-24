{invariant} = require './utils'

R = (path, component, transformers...) ->
  route = {path, component}
  for transformer in transformers
    route = transformer route
  route

R.child = (childRoute) -> (r) ->
  r.childRoutes = [] unless Array.isArray r.childRoutes
  r.childRoutes.push childRoute
  r

R.index = (component) -> (r) ->
  invariant 'indexRoute' not of r, 'indexRoute already added'
  r.indexRoute = component
  r

module.exports = R
