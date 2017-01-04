"use strict";

var R = function R(path, component) {
  for (var _len = arguments.length, transformers = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
    transformers[_key - 2] = arguments[_key];
  }

  var route = { path: path, component: component };
  for (var i = 0; i < transformers.length; i++) {
    route = transformers[i](route);
  }
  return route;
};

var index = function index(component) {
  return function (r) {
    if ("indexRoute" in r) {
      console.error("indexRoute already exists!", r);
    }
    r.indexRoute = component;
    return r;
  };
};

var child = function child(childRoute) {
  return function (r) {
    if (!Array.isArray(r.childRoutes)) {
      r.childRoutes = [];
    }
    r.childRoutes.push(childRoute);
    return r;
  };
};

module.exports = { R: R, index: index, child: child };

