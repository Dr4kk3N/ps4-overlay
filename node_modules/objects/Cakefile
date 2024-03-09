path          = require "path"
{spawn, exec} = require "child_process"
fs            = require "fs"


launch = (cmd, args = [], options = {}, callback) ->
  app = spawn(cmd, args, options)
  app.on "exit", (status) -> callback?() if status is 0
  return app
  
runTests = (path, watch) ->
  env = process.env
  env.NODE_ENV = "test"
  args = ["--growl", "--compilers", "coffee:coffee-script", "-R", "list", "-t", "4000"]
  if watch
    args.push "--watch"
  if Array.isArray path
    Array::push.apply args, path
  else
    args.push path
  launch "./node_modules/mocha/bin/mocha", args, {env: env, customFds: [0,1,2]}




task "test", "Test suite", ->
  runTests "test/objects.test.coffee"