function onKill(player, target, lastHit)
 
local tasks = {

["rat"] =            {killsRequired = 100,  storage = 9001},
["minotaur"] =       {killsRequired = 500, storage = 9002},
["ghoul"] =          {killsRequired = 300, storage = 9003},
["cyclops"] =        {killsRequired = 200, storage = 9004},
["ancient scarab"] = {killsRequired = 175, storage = 9006},
["dragon"] =         {killsRequired = 500, storage = 9007},
["necromancer"] =    {killsRequired = 200, storage = 9008},
["giant spider"] =   {killsRequired = 300, storage = 9009},
["warlock"] =        {killsRequired = 150, storage = 9012},
["demon"] =          {killsRequired = 2000, storage = 9013},
["goblin"] =         {killsRequired = 100, storage = 9014},
["larva"] =          {killsRequired = 500, storage = 9015},
["rotworm"] =        {killsRequired = 100, storage = 9016},
["orc"] =            {killsRequired = 100, storage = 9017},
["orc berserker"] =  {killsRequired = 100, storage = 9017},
["orc leader"] =     {killsRequired = 100, storage = 9017},
["orc rider"] =      {killsRequired = 100, storage = 9017},
["orc shaman"] =     {killsRequired = 100, storage = 9017},
["orc spearman"] =   {killsRequired = 100, storage = 9017},
["orc warlord"] =    {killsRequired = 100, storage = 9017},
["orc warrior"] =    {killsRequired = 100, storage = 9017},
["scarab"] =         {killsRequired = 250, storage = 9018},
["troll"] =          {killsRequired = 50, storage = 9019},
["black knight"] =   {killsRequired = 50, storage = 9020},
["demon skeleton"] = {killsRequired = 200, storage = 9021},
["dwarf guard"] =    {killsRequired = 300, storage = 9022},
["fire elemental"] = {killsRequired = 50, storage = 9023},
["hero"] =           {killsRequired = 100, storage = 9024},
["vampire"] =        {killsRequired = 250, storage = 9025},
["snake"] =          {killsRequired = 100, storage = 9026},
["wasp"] =           {killsRequired = 100, storage = 9027},
["wolf"] =           {killsRequired = 100, storage = 9028},
["dwarf"] =          {killsRequired = 150, storage = 9029},
["dwarf soldier"] =  {killsRequired = 200, storage = 9030},
["cave rat"] =       {killsRequired = 100, storage = 9031},
["amazon"] =         {killsRequired = 200, storage = 9032},
["valkyrie"] =       {killsRequired = 200, storage = 9033},
["scorpion"] =       {killsRequired = 50, storage = 9034},
["lion"] =           {killsRequired = 50, storage = 9035},
["dragon lord"] =   {killsRequired = 400, storage = 9036},
["poison spider"] =  {killsRequired = 130, storage = 9037},
["wild warrior"] =   {killsRequired = 150, storage = 9038},
["slime"] =          {killsRequired = 300, storage = 9039},
["hunter"] =         {killsRequired = 200, storage = 9040},
["bonebeast"] =      {killsRequired = 200, storage = 9041},
["elf"] =            {killsRequired = 100, storage = 9042},
["elf scout"] =      {killsRequired = 150, storage = 9043},
["elf arcanist"] =   {killsRequired = 300, storage = 9044},
["swamp troll"] =    {killsRequired = 50, storage = 9045},
["frost troll"] =    {killsRequired = 100, storage = 9046},
["bug"] =            {killsRequired = 50, storage = 9047},
["hyaena"] =         {killsRequired = 50, storage = 9048},
["stone golem"] =    {killsRequired = 60, storage = 9049},
["stalker"] =        {killsRequired = 150, storage = 9050},
["ghost"] =          {killsRequired = 140, storage = 9051},
["gargoyle"] =       {killsRequired = 150, storage = 9052},
["crypt shambler"] = {killsRequired = 160, storage = 9053},
["beholder"] =       {killsRequired = 200, storage = 9054},
["minotaur mage"] =  {killsRequired = 100, storage = 9055},
["monk"] =           {killsRequired = 110, storage = 9056},
["witch"] =          {killsRequired = 50, storage = 9057},
["polar bear"] =     {killsRequired = 50, storage = 9058},
["skeleton"] =       {killsRequired = 135, storage = 9059},
["hydra"] =          {killsRequired = 400, storage = 9060},
["yeti"] =           {killsRequired = 10, storage = 9061}, 
["serpent spawn"] =  {killsRequired = 400, storage = 9062},
["behemoth"]      =  {killsRequired = 200, storage = 9063},
["mummy"]         =  {killsRequired = 300, storage = 9064},
["sibang"]        =  {killsRequired = 400, storage = 9065},
["kongra"]        =  {killsRequired = 400, storage = 9065},
["merlkin"]       =  {killsRequired = 400, storage = 9065},
}

local targetName = target:getName():lower()
local monster = tasks[targetName]


   if monster and player:getStorageValue(monster.storage) >= 0 and player:getStorageValue(monster.storage) <= monster.killsRequired then
      player:setStorageValue(monster.storage, player:getStorageValue(monster.storage) + 1)
      if (player:getStorageValue(monster.storage) == monster.killsRequired) then
          player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "Congratulations! you have killed total of ["..monster.killsRequired.."] "..target:getName().."s and finished the task!.")
          player:setStorageValue(monster.storage, (monster.killsRequired)+1)
      else
          player:sendTextMessage(MESSAGE_STATUS_CONSOLE_BLUE, "You have killed ["..player:getStorageValue(monster.storage).."/"..monster.killsRequired.." "..target:getName().."s].")
      end
   end
 return true
end
