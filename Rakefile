# Rakefile for lxUnit
# Interesting targets are:
#  $ rake test : runs unit tests

task :test do
  sh "LUA_PATH=./src/main/lxUnit/framework/?.lua lua src/test/lxUnit/framework/test_assert.lua"
  sh "LUA_PATH=./src/main/lxUnit/framework/?.lua lua src/test/lxUnit/framework/test_test_failure.lua"
end