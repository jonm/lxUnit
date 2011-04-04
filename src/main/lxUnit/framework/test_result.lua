TestResult = {}

function TestResult:new()
   tr = {}
   setmetatable(tr, self)
   self.__index = self
   tr.fFailures = {}
   tr.fErrors = {}
   tr.fListeners = {}
   tr.fRunTests = 0
   tr.fStop = false;
   return tr
end

function TestResult:addError(test, err)
   -- TODO: need TestFailure
end