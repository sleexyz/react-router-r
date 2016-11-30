/* @flow */

/*::

type Component = Object

type IndexRoute = {component: Component}

type Route = {
  path: string,
  component: Component,
  childRoutes?: Array<Route>,
  indexRoute?: IndexRoute
}

*/

const R /*: (path : string, component : Component, ...transformers : Array<(route: Route) => Route>) => Route */
= (path, component, ...transformers) => { let route = {path, component};
  for (let transform of transformers) {
    route = transform(route);
  }
  return route;
};


const index /*: (component : Component) =>  (r : Route) => Route */
= component => function(r) {
  if ("indexRoute" in r) {
    console.error("indexRoute already exists!", r);
  }
  Object.assign(r, {indexRoute: {component}});
  return r;
};

const child /*: (childRoute : Route) => (r : Route) => Route */
= childRoute => function (r) {
  if (!Array.isArray(r.childRoutes)) {
    r.childRoutes = [];
  }
  r.childRoutes.push(childRoute);
  return r;
};


module.exports = {R, index, child};
