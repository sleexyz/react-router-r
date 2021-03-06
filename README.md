# React Router R
[![CircleCI](https://circleci.com/gh/sleexyz/react-router-r.svg?style=svg)](https://circleci.com/gh/sleexyz/react-router-r)
[![npm version](https://badge.fury.io/js/react-router-r.svg)](https://badge.fury.io/js/react-router-r)

This library provides a declarative DSL for constructing React Router routes.

It exposes a function `R`, which takes:

- 1 - a *path*

- 2 - a *component*

- (3...n) - optional route *transformers*, i.e. functions of type `Route → Route`

and returns a valid Route, aka a React Router [plain route](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#plainroute).

---

React Router R is designed for optimal readability in Coffeescript, so documentation and examples are in Coffeescript.

---

## Example:

```coffeescript
{R, index, child} = require 'react-router-r'

...

routes = R "/", App,
  index Landing
  child R "welcome", Landing
  child R "about", About,
    index AboutAll
    child R "foo", AboutFoo
    child R "bar", AboutBar
```

*reduces to:*

```javascript
const routes = {
  path: "/",
  component: App,
  indexRoute: { component: Landing },
  childRoutes: [
    { 
      path: "welcome",
      component: Landing 
    },
    { 
      path: "about", 
      component: Landing ,
      indexRoute: { component: AboutAll },
      childRoutes: [
        { path: "foo", component: AboutFoo },
        { path: "bar", component: AboutBar }
      ]
    }
  ]
}
```

See [./example](./example) for the whole application.

## Installation:
```
yarn add react-router-r
```

## Basics:

### Build a route:
```coffeescript
R '/', App
```

*reduces to:*

```js
{ path: "/", component: App }
```

### Build a route with child routes:

```coffeescript
R '/', App,
  index Landing
  child R 'welcome', Landing
  child R 'about, About
```

*reduces to:*

```js
{
  path: "/",
  component: App,
  indexRoute: { component: Landing },
  childRoutes: [
    { path: 'welcome', component: Landing },
    { path: 'about', component: About }
  ]
}
```

## Route Transformers:
React Router R takes and applies functions that take a React Route (as a plain route object) and returns a React Route. We call these functions *route transformers*. Note these transformers may mutate and return their input.

The following transformers are provided out of the box:

</br>

#### `index`
```
index : (component : Component) → (route : Route) → Route
```

Adds an [`indexRoute`](https://github.com/ReactTraining/react-router/blob/master/docs/guides/IndexRoutes.md) with the specified component to the route.

</br>

#### `child`
```
child : (childRoute : Route) → (route : Route) → Route
```

Adds a child route to the route.

</br>

#### `dynamic`
```
dynamic : ({
  path? : String,
  component? : Component,
  getRoute : (∀b. (returnRoute : ((route : Route) → b)) → b)
}) → (route : Route) → Route
```

Adds a child route with the optionally provided `path` and `component` with a dynamically generated grandchild route. Uses React Router's [`getIndexRoute`](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#getindexroutepartialnextstate-callback) and [`getChildRoutes`](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#getchildroutespartialnextstate-callback) under the hood.

`dynamic` can be used as is, but is more meant to be further abstracted upon for building application-specific dynamic route transformers. It serves as a mid-level API on top of the default low-level React Router dynamic routing API.

</br>

## Write your own transfomers!

Writing route transformers is easy!

For example, let's write one that adds basic support for React Router's [`onEnter`](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#onenternextstate-replace-callback) field:

```coffeescript
onEnter = (onEnterCallback) -> (route) ->
  if ('onEnter' in route) throw new Error "onEnter is already defined!"
  route.onEnter = onEnterCallback
  route
```

Now, we can use it in our routes:

---


```coffeescript
R '/', App, 
  onEnter (nextState, replace, cb) -> ...
```

*reduces to:*

```javascript
{
  path: "/",
  component: App,
  onEnter: function(nextState, replace, cb) {
    ...
  }
}
```
