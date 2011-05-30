require("assert")
require("test_failure")

tests = {}

function tests.failedTestReturnsTest()
   o = {}
   tf = TestFailure:new(o, nil)
   Assert.assertEquals(o, tf:failedTest())
end

function tests.thrownErrorReturnsError()
   o = {}
   tf = TestFailure:new(nil, o)
   Assert.assertEquals(o, tf:thrownError())
end

function tests.errorMessageCanBeExtracted()
   err = "msg\ntrace"
   o = {}
   tf = TestFailure:new(o, err)
   Assert.assertEquals("msg", tf:errorMessage())
end

function tests.convertsToString()
   o = {}
   o.toString = function () return "test" end
   err = "msg\ntrace"
   tf = TestFailure:new(o, err)
   Assert.assertEquals("test: msg", tf:toString())
end

function tests.isNotAFailureIfNotAssertionFailed()
   tf = TestFailure:new({}, "msg\ntrace")
   Assert.assertFalse(tf:isFailure())
end

function tests.failedAssertionIsRecognizedAsFailure()
   _, err = pcall(function () Assert.fail("msg") end)
   tf = TestFailure:new({}, err)
   Assert.assertTrue(tf:isFailure())
end

local function verbose()
   if arg == nil then return false end
   for _,k in ipairs(arg) do
      if k == "-v" then return true end
   end
   return false
end

local function runTest(test)
   cnt = cnt + 1
   status, err = xpcall(function () tests[test]() end,
			debug.traceback)
   if status then
      if verbose() then print("  " .. test .. ": PASS") end
      passes = passes + 1
   else
      print("  " .. test .. ": FAIL")
      print(err)
   end
end

function main()
   cnt = 0
   passes = 0
   table.foreach(tests, runTest)
   print("test_test_failure.lua: passed " .. passes .. "/" .. cnt .. " tests")
   if passes ~= cnt then error("There were test failures.") end
end

main()

