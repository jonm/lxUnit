require("comparison_compactor")

tests = {}

function tests.findsCommonPrefixOfLengthOne()
   cc = ComparisonCompactor:new(2, "abcdef", "axcdef")
   cc:findCommonPrefix()
   Assert.assertEquals(1, cc.fPrefix)
end

function tests.findsZeroCommonPrefixWhenNone()
   cc = ComparisonCompactor:new(2, "abc", "xbc")
   cc:findCommonPrefix()
   Assert.assertEquals(0, cc.fPrefix)
end

function tests.findsFullCommonPrefixOnSameString()
   cc = ComparisonCompactor:new(2, "abc", "abc")
   cc:findCommonPrefix()
   Assert.assertEquals(3, cc.fPrefix)
end

function tests.findsFullCommonPrefixWhenExpectedShorter()
   cc = ComparisonCompactor:new(2, "abc", "abcdef")
   cc:findCommonPrefix()
   Assert.assertEquals(3, cc.fPrefix)
end

function tests.findsFullCommonPrefixWhenActualShorter()
   cc = ComparisonCompactor:new(2, "abcdef", "abc")
   cc:findCommonPrefix()
   Assert.assertEquals(3, cc.fPrefix)
end

function tests.truncatesPrefixToContextLength()
   cc = ComparisonCompactor:new(2, "abcdef", "abc")
   cc:findCommonPrefix()
   Assert.assertEquals("...bc", cc:computeCommonPrefix())
end

function tests.doesNotTruncatePrefixIfShorterThanContextLength()
   cc = ComparisonCompactor:new(4, "abcdef", "abc")
   cc:findCommonPrefix()
   Assert.assertEquals("abc", cc:computeCommonPrefix())
end

function tests.findsZeroCommonSuffixIfNoneInCommon()
   cc = ComparisonCompactor:new(2, "abc", "abx")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals(0, cc.fSuffix)
end

function tests.findsOneCommonSuffixWithOneInCommon()
   cc = ComparisonCompactor:new(2, "abc", "xxc")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals(1, cc.fSuffix)
end

function tests.commonSuffixDoesNotIncludeCommonPrefix()
   cc = ComparisonCompactor:new(2, "abc", "abc")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals(3, cc.fPrefix)
   Assert.assertEquals(0, cc.fSuffix)
end

function tests.findsCommonSuffixWithErrorInMiddle()
   cc = ComparisonCompactor:new(2, "abc", "axc")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals(1, cc.fSuffix)
end

function tests.findsCommonSuffixWithShorterExpected()
   cc = ComparisonCompactor:new(2, "xabc", "zzzabc")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals(3, cc.fSuffix)
end

function tests.findsCommonSuffixWithShorterActual()
   cc = ComparisonCompactor:new(2, "zzzabc", "xabc")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals(3, cc.fSuffix)
end

function tests.doesNotTruncateCommonSuffixIfEnoughContext()
   cc = ComparisonCompactor:new(3, "abcd", "xbcd")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals("bcd", cc:computeCommonSuffix())
end

function tests.truncatesCommonSuffixToContextLength()
   cc = ComparisonCompactor:new(2, "abcd", "xbcd")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals("bc...", cc:computeCommonSuffix())
end

function tests.isolatesDifferingInternalString()
   cc = ComparisonCompactor:new(2, "abc", "axc")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals("a[b]c", cc:compactString("abc"))
end

function tests.isolatesMissingInternalString()
   cc = ComparisonCompactor:new(2, "abcd", "abxcd")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals("ab[]cd", cc:compactString("abcd"))
end

function tests.isolatesExtraInternalString()
   cc = ComparisonCompactor:new(2, "abcd", "abxcd")
   cc:findCommonPrefix()
   cc:findCommonSuffix()
   Assert.assertEquals("ab[x]cd", cc:compactString("abxcd"))
end

function tests.identifiesDifferingInternalString()
   cc = ComparisonCompactor:new(2, "abecd", "abxcd")
   Assert.assertEquals("msg expected:<ab[e]cd> but was:<ab[x]cd>",
		       cc:compact("msg"))
end

function tests.identifiesMissingInternalString()
   cc = ComparisonCompactor:new(2, "abecd", "abcd")
   Assert.assertEquals("msg expected:<ab[e]cd> but was:<ab[]cd>",
		       cc:compact("msg"))
end

function tests.identifiesExtraInternalString()
   cc = ComparisonCompactor:new(2, "abcd", "abxcd")
   Assert.assertEquals("msg expected:<ab[]cd> but was:<ab[x]cd>",
		       cc:compact("msg"))
end

function tests.identifiesDifferingInternalStringLongContext()
   cc = ComparisonCompactor:new(2, "1234a1234", "1234x1234")
   Assert.assertEquals("msg expected:<...34[a]12...> but was:<...34[x]12...>",
		       cc:compact("msg"))
end

function tests.identifiesDifferingStart()
   cc = ComparisonCompactor:new(2, "123abc", "456abc")
   Assert.assertEquals("msg expected:<[123]ab...> but was:<[456]ab...>",
		       cc:compact("msg"))
end

function tests.identifiesDifferingEnd()
   cc = ComparisonCompactor:new(2, "abc123", "abc456")
   Assert.assertEquals("msg expected:<...bc[123]> but was:<...bc[456]>",
		       cc:compact("msg"))
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
   print("test_comparison_compactor.lua: passed " .. passes .. "/" .. cnt .. " tests")
   if passes ~= cnt then error("There were test failures.") end
end

main()


