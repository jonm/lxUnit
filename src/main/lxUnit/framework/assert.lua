Assert = {}

function Assert.assertTrue(condition, message)
   if not condition then Assert.fail(message) end
end

function Assert.assertFalse(condition, message)
   Assert.assertTrue(not condition, message)
end

function Assert.fail(message)
   if message == nil then error("AssertionFailedError") end
   error("AssertionFailedError: " .. message)
end

function Assert.assertEquals(expected, actual, message)
   if expected == actual then return end
   Assert.failNotEquals(expected, actual, message)
end

function Assert.assertNotNil(x, message)
   message = message or "Expected non-nil but was <nil>"
   Assert.assertTrue(x ~= nil, message)
end

function Assert.assertNil(x, message)
   if x == nil then return end
   message = message or ("Expected: <nil> but was: " .. x)
   Assert.assertTrue(x == nil, message)
end

function Assert.failNotEquals(expected, actual, message)
   Assert.fail(Assert.format(expected, actual, message))
end

function Assert.format(expected, actual, message)
   formatted = ""
   if (message ~= nil and message ~= "") then
      formatted = message .. " "
   end
   return (formatted .. "expected:<" .. expected
	   .. "> but was:<" .. actual .. ">")
end
