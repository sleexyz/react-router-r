# React Router R

This library provides a minimal, extensible DSL for writing React Router routes. 

It exposes a function `R`, which takes:

- 1 -  a *path*

- 2 -  a *component*

- (3...n) -  optional route *mutators* 

and returns a valid [plain route](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#plainroute).

---

React Router R is designed for optimal readability in Coffeescript, so documentation and examples are in Coffeescript.

---

## Example:

```coffeescript
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

## Mutators:
Mutators are just functions that mutate their input. React Router R takes functions that mutate a React Router plain route object.

The following mutators are provided out of the box:

</br>

#### `index : (component : Component) → (route : Route) → undefined`

Adds an [`indexRoute`](https://github.com/ReactTraining/react-router/blob/master/docs/guides/IndexRoutes.md) with the specified component to the route.

</br>

#### `child : (childRoute : Route) → (route : Route) → undefined`

Adds a child route to the route.

</br>

## Write your own mutators!

Writing mutators is easy and is encouraged! 

For example, let's write one that adds basic support for React Router's [`onEnter`](https://github.com/ReactTraining/react-router/blob/master/docs/API.md#onenternextstate-replace-callback) field:

```coffeescript
onEnter = (onEnterCallback) -> (route) ->
  if ('onEnter' in route) throw new Error "onEnter is already defined!"
  route.onEnter = onEnterCallback
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

---

## List of Mutators:
Submit a PR to have your mutator listed.

- [index](https://github.com/sleexyz/react-router-r/blob/master/index.js)
- [child](https://github.com/sleexyz/react-router-r/blob/master/index.js)
