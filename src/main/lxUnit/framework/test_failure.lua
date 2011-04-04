TestFailure = {}

function TestFailure.new(failedTest, thrownError)
   tf = {}
   setmetatable(tf, self)
   tf.fFailedTest = failedTest
   tf.fThrownError = thrownError
   return tf
end

function TestFailure:failedTest()
   return self.fFailedTest
end

function TestFailure:thrownError()
   return self.fThrownError
end

function TestFailure:errorMessage()
   index = self:thrownError():find("\n")
   if index == nil then return err end
   return self:thrownError():sub(1, index-1)
end

function TestFailure:toString()
   return self:fFailedTest():toString() .. ": " .. self:errorMessage()
end

function TestFailure:trace()
   return self:thrownError()
end

function TestFailure:isFailure()
   return self:thrownError():find("AssertionFailedError") == 1
end