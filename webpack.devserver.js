/*global require, process*/
var express = require("express")
var webpack = require("webpack")
var http = require("http")
var config = require("./webpack.config")

var app = express()
var compiler = webpack(config)

app.use(require("webpack-dev-middleware")(compiler, {
  noInfo: true,
  publicPath: config.output.publicPath
}))

app.use(require("webpack-hot-middleware")(compiler, {
  log: console.log, path: "/__webpack_hmr"
}))

app.use(function(req, res){
  res.setHeader("Access-Control-Allow-Origin", "*")
})

var server = http.createServer(app)
server.listen(4001, function() {
  console.log("Listening on %j", server.address())
})

process.stdin.resume()
process.stdin.on("end", function() {
  process.exit(0)
})
