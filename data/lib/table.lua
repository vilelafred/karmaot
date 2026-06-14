function Protocol_create(byte)
   local protocol      = {}
         protocol[1]   = {}
         protocol[2]   = 0
         protocol[3]   = byte
  
   return protocol
end

function Protocol_add(protocol, string)
   table.insert(protocol[1], string)
end

function Protocol_read(protocol)
   protocol[2] = protocol[2] + 1

   return protocol[1][protocol[2]]
end

-- table.join :: [a] -> [a] -> [a]      
-- Funcao impura, pois nao cria uma nova tabela, e sim joga os valores de `table_to_join` em `table` que foi passado por referência e não por valor
table.join_ = function (xs, xs_to_join)
  for _, x in pairs(xs_to_join) do
    table.insert(xs, x)
  end
end


------ Prelude + other table functions
table.filterFind = function (xs, foo)
  for index, value in pairs(xs) do
    if foo(index, value) then
      return {index = index, value = value}
    end
  end
  return nil
end

table.random = function (xs)
  return xs[math.random(1, #xs)]
end

-- table.concatMapStr :: [a] -> (a -> Char/String) -> String
table.concatMapStr = function (xs, foo)
  local retorno = ""
  for index, value in pairs(xs) do
    retorno = retorno .. foo(index, value)
  end
  return retorno
end

-- table.concatMap :: [[a]] -> [a]
table.concatMap = function (xs)
  local retorno = {}
  for index, table_value in pairs(xs) do
    for index, value in pairs(table_value) do
      table.insert(retorno, value)
    end 
  end
  return retorno
end

table.map = function (xs, foo)
  local retorno = {}
  for index, value in pairs(xs) do
    retorno[index] = foo(index, value)
  end
  return retorno
end

-- Impure map, passa por referencia e pode mudar o valor de `xs` caso bem entender
table.map_ = function (xs, foo)
  for index, value in pairs(xs) do
    foo(index, value)
  end
end

table.foldr = function (xs, start_value, foo)
  local retorno = start_value
  for _, value in pairs(xs) do
    retorno = foo(retorno, value)
  end
  return retorno
end

table.filter = function (xs, foo)
  local retorno = {}
  for index, value in pairs(xs) do
    if foo(index, value) then
      retorno[index] = value
    end
  end
  return retorno
end

table.any = function (xs, foo)
  for index, value in pairs(xs) do
    if foo(index, value) then
      return true
    end
  end
  return false
end

table.all = function (xs, foo)
  for index, value in pairs(xs) do
    if not foo(index, value) then
      return false
    end
  end
  return true
end

table.none = function (xs, foo)
  --local clock = os.clock()
  for index, value in pairs(xs) do
    if foo(index, value) then
      return false
    end
  end
  --print('> Tempo: ' .. (os.clock() - clock))  
  return true
end
----------------------- F I M    P R E L U D E ---------------------------------
--------------------------------------------------------------------------------

table.toString = function(elem)
    if type(elem) == "table" then
        local str = "{"
        for k, v in pairs(elem) do
            local index = type(k) == "string" and (k .. ' = ') or "" 
            str = str .. index .. table.toString(v) .. ', '  
        end
        return string.sub(str, 1, str:len() - 2) .. "}"
    else
        return type(elem) == 'string'   and ("'" .. elem .. "'")
            or type(elem) == 'boolean'  and (elem and 'true' or 'false')
            or type(elem) == 'nil'      and '__nil__'
            or type(elem) == 'function' and '__func__'
            or elem
    end
end

--------------------------------------------------------------------------------
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end

function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str(v) )
    done[ k ] = true
  end
  for k, v in pairs(tbl) do
    if not done[k] then
      table.insert(result, table.key_to_str(k) .. "=" .. table.val_to_str(v))
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end
--------------------------------------------------------------------------------

table.find = function (table, value)
    for i, v in pairs(table) do
        if v == value then
            return i
        end
    end

    return nil
end

table.contains = function (txt, str)
    for i, v in pairs(str) do
        if(txt:find(v) and not txt:find('(%w+)' .. v) and not txt:find(v .. '(%w+)')) then
            return true
        end
    end

    return false
end
table.isStrIn = table.contains

table.count = function (table, item)
    local count = 0
    for i, n in pairs(table) do
        if(item == n) then
            count = count + 1
        end
    end

    return count
end
table.countElements = table.count

table.getCombinations = function (table, num)
    local a, number, select, newlist = {}, #table, num, {}
    for i = 1, select do
        a[#a + 1] = i
    end

    local newthing = {}
    while(true) do
        local newrow = {}
        for i = 1, select do
            newrow[#newrow + 1] = table[a[i]]
        end

        newlist[#newlist + 1] = newrow
        i = select
        while(a[i] == (number - select + i)) do
            i = i - 1
        end

        if(i < 1) then
            break
        end

        a[i] = a[i] + 1
        for j = i, select do
            a[j] = a[i] + j - i
        end
    end

    return newlist
end

function table.serialize(t)
    local mark = {}
    local assign = {}

    local function ser_table(tbl, parent)
        mark[tbl] = parent
        local tmp = {}
        for k, v in pairs(tbl) do
            local key = type(k) == "number" and "[" .. k .. "]" or string.format("[%q]", k)
            if type(v) == "table" then
                local dotkey = parent .. key
                if mark[v] then
                    table.insert(assign, dotkey .. " = " .. mark[v])
                else
                    table.insert(tmp, key .. " = " .. ser_table(v, dotkey))
                end
            else
                local val = type(v) == "number" and v or string.format("%q", v)
                table.insert(tmp, key .. " = " .. val)
            end
        end
        return "{" .. table.concat(tmp, ", ") .. "}"
    end

    return ser_table(t, "ret") .. table.concat(assign, " ")
end

function table.unserialize(lua)
    local func = load("return " .. lua)
    if func == nil then return nil end
    return func()
end
