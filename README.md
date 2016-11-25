# React Router R

This library provides an extensible DSL for writing React Router routes. 

It exposes a function `R`, which takes:

1. a *path*

2. a *component*

(3...n). optional route *mutators* 

and returns a valid [plain route](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#plainroute).

---

React Router R is optimized for readability in Coffeescript, so documentation/examples are in Coffeescript.

## Example:

`routes` is a valid React Router route:

```coffeescript
routes = R "/", App,
  index Landing
  child R "welcome", Landing
  child R "about", About,
    index AboutAll
    child R "foo", AboutFoo
    child R "bar", AboutBar
```

See [./example](./example) for the whole application.

## Installation:
```
yarn add react-router-r
```

## Basics:
### Build a route:

*R*
```coffeescript
R '/', App
```

evaluates to:

*plain route*
```js
{ path: "/", component: App }
```

### ...with child routes

*R*
```coffeescript
R '/', App,
  index Landing
  child R 'welcome', Landing
  child R 'about, About
```

evaluates to:

*plain route*
```js
{
  path: "/",
  component: App,
  indexRoute: {component: Landing},
  childRoutes: [
    {path: 'welcome', component: Landing},
    {path: 'about, component: About}
  ]
}
```

## Mutators:
Mutators are functions that mutate their input.

The following mutators are provided out of the box:

#### `index : Component -> Route -> (Void)`
Adds an `indexRoute` with the specified Component to the route.

#### `child : Route -> Route -> (Void)`
Adds a child route to the route.

## Write your own mutators

Writing mutators is easy and is encouraged! For example, let's write one that adds basic support for React Router's [`onEnter`](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#onenternextstate-replace-callback) field:

```coffeescript
onEnter = (onEnterCallback) -> (route) ->
  if ('onEnter' in route) throw new Error "onEnter is already defined!"
  route.onEnter = onEnterCallback
```

Now, we can use it in our routes:

*R*
```coffeescript
R '/', App, 
  onEnter (nextState, replace, cb) -> ...
```

*plain route*:
```javascript
{
  path: "/",
  component: App,
  onEnter: function(nextState, replace, cb) {
    ...
  }
}
```

