module.exports = {
  entry: "./index.coffee",
  output: {
    path: __dirname,
    filename: "bundle.js"
  },
  module: {
    loaders: [
      {test: /\.coffee$/, include: __dirname + "/index.coffee", loader: "coffee"}
    ]
  },
}
