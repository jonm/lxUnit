require("assert")

tests = {}

function tests.failThrowsError()
   status, _ = pcall(function () Assert.fail() end)
   if status then error() end
end

function tests.failWithMessageThrowsError()
   status, _ = pcall(function () Assert.fail("msg") end)
   if status then error() end
end

function tests.failWithMessageIncludesMessageInError()
   status, err = pcall(function () Assert.fail("msg") end)
   if err.message ~= "msg" then error() end
end

function tests.failWithoutMessageHasNilMessageInError()
   status, err = pcall(function () Assert.fail() end)
   if err.message ~= nil then error() end
end

function tests.assertTrueWorksOnTrue()
   Assert.assertTrue(true)
end

function tests.assertTrueThrowsErrorOnFalse()
   status, _ = pcall(function () Assert.assertTrue(false) end)
   if status then error() end
end

function tests.assertTrueWithMessageWorksOnTrue()
   Assert.assertTrue(true,"msg")
end

function tests.assertTrueWithMessageThrowsErrorOnFalse()
   status, err = pcall(function () Assert.assertTrue(false, "msg") end)
   if status then error() end
   if err.message ~= "msg" then error() end
end

function tests.assertFalseWorksOnFalse()
   Assert.assertFalse(false)
end

function tests.assertFalseThrowsErrorOnTrue()
   status, _ = pcall(function () Assert.assertFalse(true) end)
   if status then error() end
end

function tests.assertFalseWithMessageWorksOnFalse()
   Assert.assertFalse(false,"msg")
end

function tests.assertFalseWithMessageThrowsErrorOnTrue()
   status, err = pcall(function () Assert.assertFalse(true, "msg") end)
   if status then error() end
   if err.message ~= "msg" then error() end
end

function tests.assertEqualsWorksForNilAndNil()
   Assert.assertEquals(nil,nil)
end

function tests.assertEqualsThrowsErrorForNilAndSomethingElse()
   status, err = pcall(function () Assert.assertEquals(nil,1) end)
   if status then error() end
end

function tests.assertEqualsWorksForEqualNumbers()
   Assert.assertEquals(1,1)
end

function tests.assertEqualsThrowsErrorForUnequalNumbers()
   status, err = pcall(function () Assert.assertEquals(1,2) end)
   if status then error() end
end

function tests.assertEqualsThrowsErrorForMismatchedTypes()
   status, err = pcall(function () Assert.assertEquals(1,"b") end)
   if status then error() end
end

function tests.assertEqualsWorksForEqualStrings()
   Assert.assertEquals("a","a")
end

function tests.assertEqualsThrowsErrorForUnequalStrings()
   status, err = pcall(function () Assert.assertEquals("a","b") end)
   if status then error() end
end

function tests.assertEqualsWorksForEqualBooleans()
   Assert.assertEquals(true,true)
end

function tests.assertEqualsThrowsErrorForUnequalBooleans()
   status, err = pcall(function () Assert.assertEquals(true,false) end)
   if status then error() end
end

function tests.assertEqualsWorksForTheSameFunction()
   Assert.assertEquals(print,print)
end

function tests.assertEqualsThrowsErrorsForFunctionsThatAreNotTheSame()
   f = function () return 1 end
   g = function () return 1 end
   status, _ = pcall(function () Assert.assertEquals(f,g) end)
   if status then error() end
end

function tests.assertEqualsWorksForTheSameTable()
   t1 = {}
   t2 = t1
   Assert.assertEquals(t1,t2)
end

function tests.assertEqualsThrowsErrorsForTablesThatAreNotTheSame()
   f = {}
   g = {}
   status, _ = pcall(function () Assert.assertEquals(f,g) end)
   if status then error() end
end

function tests.assertNotNilWorksForNonNilValue()
   Assert.assertNotNil(1)
end

function tests.assertNotNilThrowsErrorForNil()
   status, _ = pcall(function () Assert.assertNotNil(nil) end)
   if status then error() end
end

function tests.assertNilWorksForNil()
   Assert.assertNil(nil)
end

function tests.assertNilThrowsErrorForNonNil()
   status, _ = pcall(function () Assert.assertNil(1) end)
   if status then error() end
end

function main()
   cnt = 0
   table.foreach(tests, function (test)
			   cnt = cnt + 1
			   tests[test]()
			end)
   print("test_assert.lua: passed " .. cnt .. " tests: OK")
end

main()


