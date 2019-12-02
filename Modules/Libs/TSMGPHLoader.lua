TSMGPHLoader = {}

local alreadyExist = false;

if(TSMGPH) then
  alreadyExist = true;
end

local module = {}
local modules = {}

function TSMGPHLoader:CreateBlankModule()
    local ret = {}
    ret.private = {}
    return ret
end

function TSMGPHLoader:CreateModule(name)
  if (not modules[name]) then
    modules[name] = TSMGPHLoader:CreateBlankModule()
    return modules[name]
  else
    return modules[name]
  end
end

function TSMGPHLoader:ImportModule(name)
  if (not modules[name]) then
    modules[name] = TSMGPHLoader:CreateBlankModule()
    return modules[name]
  else
    return modules[name]
  end
end