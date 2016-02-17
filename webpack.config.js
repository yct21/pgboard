/*global require, process, __dirname, module*/
var path = require("path")
var webpack = require("webpack")

var env = process.env.MIX_ENV || "dev"
var prod = env === "prod"
var plugins = [new webpack.optimize.OccurenceOrderPlugin(), new webpack.NoErrorsPlugin(), new webpack.IgnorePlugin(/ReactContext/)]
var publicPath = "http://localhost:4001/"
var buildPath = "priv/static/js"

// entries
var urlforWebpackHotMiddleware = "webpack-hot-middleware/client?path=http://localhost:4001/__webpack_hmr&timeout=3000&noInfo=true"

var entry =
  prod ?
  [path.resolve(__dirname, "frontend/main.js")] :
  [urlforWebpackHotMiddleware, path.resolve(__dirname, "frontend/main.js")]

if (prod) {
  plugins.push(new webpack.optimize.UglifyJsPlugin())
} else {
  plugins.push(new webpack.HotModuleReplacementPlugin())
}

var config =  {
  devtool: prod ? null : "eval-source-map",
  entry: entry,
  resolve: {
    root: __dirname + "/frontend",
    extensions: ["", ".js", ".jsx"]
    // alias: {
    //   "actions": __dirname + "/frontend/actions",
    //   "components": __dirname + "/frontend/components",
    //   "reducers": __dirname + "/frontend/reducers",
    //   "websocket": __dirname + "/frontend/websocket",
    //   "styles": __dirname + "/frontend/styles",
    //   "icons": __dirname + "/frontend/icons",
    //   "gameIndex": __dirname + "/frontend/gameIndex"
    // }
  },
  output: {
    path: path.resolve(__dirname, buildPath),
    filename: "app.js",
    publicPath: publicPath
  },
  plugins: plugins,
  module: {
    loaders: [{
      test: /\.js$/,
      exclude: /node_modules/,
      loader: "babel-loader"
    }, {
      test: /test\/frontend\/.*\.test\.js$/,
      loader: "mocha-loader!babel-loader"
    }, {
      test: /\.(png|jpg|eot|ttf|svg|woff|woff2)$/,
      loader: "url-loader?limit=8192"
    }]
  }
}

module.exports = config
