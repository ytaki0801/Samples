function variablep(x)
  return type(x) == "string"
     and string.match(string.sub(x, 1, 1), "[A-Z]")
end

fail = false
nobindings = { t="true" }

function getbinding(var, bindings)
  return bindings[var]
end

function extendbindings(var, val, bindings)
  if bindings["t"] == "true" then
    local ebindings = {}
    ebindings[var]=val
    return ebindings
  else
    bindings[var]=val
    return bindings
  end
end

function matchvariable(var, input, bindings)
  local binding = getbinding(var, bindings)
  if not binding then
    return extendbindings(var, input, bindings)
  elseif input == binding then
    return bindings
  else
    return fail
  end
end

function patmatch(pattern, input, ...)
  local bindings = ...
  if not ... then bindings = nobindings end
  if bindings == fail then
    return fail
  elseif variablep(pattern) then
    return matchvariable(pattern, input, bindings)
  elseif pattern == input or
        (pattern[1] == nil and input[1] == nil) then
    return bindings
  elseif pattern[1] ~= nil and input[1] ~= nil then
    local p1 = table.remove(pattern, 1)
    local i1 = table.remove(input, 1)
    return patmatch(pattern, input,
                    patmatch(p1, i1, bindings))
  else
    return fail
  end
end

function patinput(x)
  local r = {}
  for w in string.gmatch(x, "[^ ]+") do
    table.insert(r, w)
  end
  return r
end

function patoutput(x)
  local r = "fail"
  if x ~= fail then
    r = ""
    for k in pairs(x) do
      r = r..k.." = "..x[k].."\n"
    end
  end
  return r
end

function dopatmatch(p, i)
  return patoutput(patmatch(patinput(p), patinput(i)))
end

-- > dopatmatch("X is simple", "it is simple")
-- X = it
-- 
-- > dopatmatch("X is Y", "it is simple")
-- Y = simple
-- X = it
-- 
-- > dopatmatch("X is Y", "it is not simple")
-- fail

