const R = (path, component, ...mutators) => {
  const route = {path, component};
  for (mutate of mutators) {
    mutate(route);
  }
  return route;
};

const index = component => r => {
  if ("indexRoute" in r) {
    console.error("indexRoute already exists!", r);
  }
  Object.assign(r, {indexRoute: {component}});
};

const child = childRoute => r => {
  if (!Array.isArray(r.childRoutes)) {
    r.childRoutes = [];
  }

  r.childRoutes.push(childRoute);
};

module.exports = {R, index, child};
