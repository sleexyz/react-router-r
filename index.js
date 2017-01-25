// Generated by CoffeeScript 1.12.3
(function() {
  var Contain, R, createElement, ensureNotIn,
    slice = [].slice;

  createElement = require('react').createElement;

  ensureNotIn = function(field, obj, msg) {
    var error;
    if (field in obj) {
      error = new Error(msg + ". Found " + field + " in route");
      error.framesToPop = 1;
      throw error;
    }
  };

  R = function() {
    var component, i, len, path, route, transformer, transformers;
    path = arguments[0], component = arguments[1], transformers = 3 <= arguments.length ? slice.call(arguments, 2) : [];
    route = {
      path: path,
      component: component
    };
    for (i = 0, len = transformers.length; i < len; i++) {
      transformer = transformers[i];
      route = transformer(route);
    }
    return route;
  };

  R.child = function(childRoute) {
    return function(route) {
      if (!Array.isArray(route.childRoutes)) {
        route.childRoutes = [];
      }
      route.childRoutes.push(childRoute);
      return route;
    };
  };

  R.index = function(component) {
    return function(route) {
      ensureNotIn('indexRoute', route, 'index can only be used once');
      route.indexRoute = {
        component: component
      };
      return route;
    };
  };

  Contain = function(parent, child) {
    return function(props) {
      return createElement(parent, {}, createElement(child, {}));
    };
  };

  R.dynamic = function(path, component, getRouteAsync) {
    return {
      path: path,
      component: component,
      getIndexRoute: function(_partialNextState, callback) {
        return getRouteAsync(function(route) {
          if (route.indexRoute != null) {
            return callback(null, {
              component: Contain(route.component, route.indexRoute.component)
            });
          } else {
            return callback(new Error('No dynamic indexRoute provided'));
          }
        });
      },
      getChildRoutes: function(_partialNextState, callback) {
        return getRouteAsync(function(route) {
          if (route.indexRoute != null) {
            return callback(null, [route]);
          } else {
            return callback(null, []);
          }
        });
      }
    };
  };

  module.exports = R;

}).call(this);
