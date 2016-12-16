"use strict";

// from react-router
var R = function R(path, component) {
  for (var _len = arguments.length, transformers = Array(_len > 2 ? _len - 2 : 0), _key = 2; _key < _len; _key++) {
    transformers[_key - 2] = arguments[_key];
  }

  var route = { path: path, component: component };
  var _iteratorNormalCompletion = true;
  var _didIteratorError = false;
  var _iteratorError = undefined;

  try {
    for (var _iterator = transformers[Symbol.iterator](), _step; !(_iteratorNormalCompletion = (_step = _iterator.next()).done); _iteratorNormalCompletion = true) {
      var transform = _step.value;

      route = transform(route);
    }
  } catch (err) {
    _didIteratorError = true;
    _iteratorError = err;
  } finally {
    try {
      if (!_iteratorNormalCompletion && _iterator.return) {
        _iterator.return();
      }
    } finally {
      if (_didIteratorError) {
        throw _iteratorError;
      }
    }
  }

  return route;
};

// from react-router


// from react


var index = function index(component) {
  return function (r) {
    if ("indexRoute" in r) {
      console.error("indexRoute already exists!", r);
    }
    Object.assign(r, { indexRoute: { component: component } });
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

