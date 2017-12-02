module.exports = {
  entry: "./js/zpids.js",
  output: {
    path: __dirname,
    filename: "index.js",
    library: 'zpids',
    libraryTarget: 'commonjs2'
  },
  module: {
    rules: [
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: {
          loader: 'babel-loader',
          options: {
            presets: [
              ["@babel/preset-env", {"targets": {"node": "current"}}]
            ]
          }
        }
      }
    ]
  }
};
