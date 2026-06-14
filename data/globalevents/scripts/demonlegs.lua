local config =
{
        day = "Monday",
        pos = , -- Posição aonde sera criado o teleport
        topos = , -- Posição pra onde o teleport ira levar o player
        time = 30, -- tempo que o teleport ira sumir em minutos
        msg_open = "Powerful demonic forces are emanating from the depths of edron.", -- mensagem ao abrir o teleport
        msg_close = "the demonic presence seems to have disappeared." -- mensagem ao fechar o teleport
}
 
local function DelTp()
        local t = getTileItemById(config.pos, 1387)
        if t then
                doRemoveItem(t.uid, 1)
                doSendMagicEffect(config.pos, CONST_ME_POFF)
        end
end
 
function onTimer()
       
        if (os.date("%A") == config.day) then
                doCreateTeleport(1387, config.topos, config.pos)
                doBroadcastMessage(config.msg_open)
                addEvent(DelTp, config.time*60*1000)
                addEvent(doBroadcastMessage, config.time*60*1000, config.msg_close)
        end
 
        return true
end







function onThink(interval, lastExecution, thinkInterval)

local config = {
pos = {x=33309, y=31592, z=13}, -- Posição aonde sera criado o teleport
topos = {x=33312, y=31592, z=12}, -- Posição pra onde o teleport ira levar o player
tpid = 1387, -- id do teleport
time = 30 -- tempo que o teleport ira sumir em minutos
}
function DelTp()
local t = getTileItemById(config.pos, config.tpid)
if t then
doRemoveItem(t.uid, 1)
doSendMagicEffect(config.pos, CONST_ME_POFF)
end
end
local time = 116

for i = 1,time do
formula = time - 1*i
addEvent(doSendAnimatedText,i*1000, config.pos, formula, 192)
end
doCreateTeleport(config.tpid, config.topos, config.pos)
doBroadcastMessage("Evento VIP foi aberto!por favor os entereçados corram para o teleport que se localiza no templo e se fechara "..config.time.." minutos")
addEvent(DelTp, config.time*60*1000)
addEvent(doBroadcastMessage, config.time*60*1000, "Evento VIP. Proximo evento em 1h.")
return true
end