require("assert")

ComparisonCompactor = {}
ComparisonCompactor.ELLIPSIS = "..."
ComparisonCompactor.DELTA_END = "]"
ComparisonCompactor.DELTA_START = "["

function ComparisonCompactor:new(contextLength, expected, actual)
   cc = {}
   setmetatable(cc, self)
   self.__index = self
   cc.fContextLength = contextLength
   cc.fExpected = expected
   cc.fActual = actual
   return cc
end

function ComparisonCompactor:compact(message)
   if self.fExpected == nil or self.fActual == nil or self.fExpected == self.fActual then
      return Assert.format(self.fExpected, self.fActual, message)
   end
   self:findCommonPrefix()
   self:findCommonSuffix()
   local expected = self:compactString(self.fExpected)
   local actual = self:compactString(self.fActual)
   return Assert.format(expected, actual, message)
end

function ComparisonCompactor:compactString(source)
   result = self.DELTA_START .. source:sub(self.fPrefix + 1, #source - self.fSuffix) .. self.DELTA_END
   if (self.fPrefix > 0) then
      result = self:computeCommonPrefix() .. result
   end
   if (self.fSuffix > 0) then
      result = result .. self:computeCommonSuffix()
   end
   return result
end

function ComparisonCompactor:findCommonPrefix()
   self.fPrefix = 0
   local after = #(self.fExpected)
   if #(self.fExpected) > #(self.fActual) then
      after = #(self.fActual)
   end
   while self.fPrefix < after do
      if self.fExpected:sub(self.fPrefix+1,self.fPrefix+1) ~= self.fActual:sub(self.fPrefix+1,self.fPrefix+1) then break end
      self.fPrefix = self.fPrefix + 1
   end
end

function ComparisonCompactor:findCommonSuffix()
   local expectedSuffix = #(self.fExpected)
   local actualSuffix = #(self.fActual)
   while actualSuffix > self.fPrefix and expectedSuffix > self.fPrefix do
      local eChar = self.fExpected:sub(expectedSuffix,expectedSuffix)
      local aChar = self.fActual:sub(actualSuffix,actualSuffix)
      if eChar ~= aChar then break end
      expectedSuffix = expectedSuffix - 1
      actualSuffix = actualSuffix - 1
   end
   self.fSuffix = #(self.fExpected) - expectedSuffix
end

function ComparisonCompactor:computeCommonPrefix()
   local preamble = ""
   if self.fPrefix > self.fContextLength then preamble = self.ELLIPSIS end
   local begin = self.fPrefix - self.fContextLength + 1
   if begin < 1 then begin = 1 end
   return preamble .. self.fExpected:sub(begin, self.fPrefix)
end

function ComparisonCompactor:computeCommonSuffix()
   local start = #(self.fExpected) - self.fSuffix + 1
   if self.fSuffix <= self.fContextLength then
      return self.fExpected:sub(start)
   else
      return self.fExpected:sub(start, start + self.fContextLength - 1) .. self.ELLIPSIS
   end
end
