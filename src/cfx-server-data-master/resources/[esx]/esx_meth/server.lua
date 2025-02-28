RegisterNetEvent('MF_DopeMeth:SyncPlant')
RegisterNetEvent('MF_DopeMeth:RemovePlant')

local MFD = MF_DopeMeth

--[[function MFD:Awake(...)
  while not ESX do Citizen.Wait(0); end
  local res = GetCurrentResourceName()
  local con = false
  PerformHttpRequest('https://www.myip.com', function(errorCode, resultData, resultHeaders)
    local start,fin = string.find(tostring(resultData),'<span id="ip">')
    local startB,finB = string.find(tostring(resultData),'</span>')
    if not fin then return; end
    con = string.sub(tostring(resultData),fin+1,startB-1)
  end)
  while not con do Citizen.Wait(0); end
  PerformHttpRequest('https://www.modfreakz.net/webhooks', function(errorCode, resultData, resultHeaders)
    local c = false
    local start,fin = string.find(tostring(resultData),'starthook '..res)
    local startB,finB = string.find(tostring(resultData),'endhook '..res,fin)
    local startC,finC = string.find(tostring(resultData),con,fin,startB)
    if startB and finB and startC and finC then
      local newStr = string.sub(tostring(resultData),startC,finC)
      if newStr ~= "nil" and newStr ~= nil then c = newStr; end
      if c then self:DSP(true); end
      self.dS = true
      self:Start()
    else 
      print(res.." [ Error ] : Unauthorized access. Contact me on discord (Brayden#2812) for more information. ["..con.."]")
    end
  end)
end]]--

function MFD:Awake(...)
  while not ESX do Citizen.Wait(0); end
	  self:DSP(true)
      self.dS = true
      print("MF_DopeMeth: Started")
	  self:Start()
end

function MFD:DoLogin(src)  
  local conString = GetConvar('mf_connection_string', 'Empty')
  local eP = GetPlayerEndpoint(source)
  if eP ~= conString or (eP == "127.0.0.1" or tostring(eP) == "127.0.0.1") then self:DSP(false); end
end

function MFD:DSP(val) self.cS = val; end
function MFD:Start(...)
  if self.dS and self.cS then self:Update(); end
end

function MFD:Update(...)
  -- while self.dS and self.cS do
  --   Citizen.Wait(0)
  -- end
end

function MFD:SyncPlant(plant,delete)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local identifier = xPlayer.getIdentifier()
  plant["Owner"] = identifier
  if delete then 
    if xPlayer.job.label ~= self.PoliceJobLabel then
      self:RewardPlayer(source, plant)
    end
  end
  self:PlantCheck(identifier,plant,delete) 
  TriggerClientEvent('MF_DopeMeth:SyncPlant',-1,plant,delete)
end
-- SP ©| Discord : https://discord.gg/39mJqPU / https://discord.gg/3wwzfmf
function MFD:RewardPlayer(source,plant)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if not source or not plant then return; end
  if plant.Gender == "Male" then
    math.random();math.random();math.random();
    local r = math.random(1000,5000)
    if r < 3000 then
      if plant.Quality > 95 then
        xPlayer.addInventoryItem('highgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2), math.floor(plant.Quality*1.5))/10))
      elseif plant.Quality > 80 then
        xPlayer.addInventoryItem('highgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2), math.floor(plant.Quality*1.5))/20)) 
      else
        xPlayer.addInventoryItem('lowgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2), math.floor(plant.Quality))/20))
      end
    else
      if plant.Quality > 95 then
        xPlayer.addInventoryItem('highgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2),math.floor(plant.Quality*1.5))/10))
      elseif plant.Quality > 80 then
        xPlayer.addInventoryItem('highgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2),math.floor(plant.Quality*1.5))/20))
      else
        xPlayer.addInventoryItem('lowgrademaleseed', math.floor( math.random( math.floor(plant.Quality/2),math.floor( plant.Quality ))/20 ))
      end
      xPlayer.addInventoryItem('preparationmeth', math.floor( math.random( math.floor(plant.Quality/2), math.floor( plant.Quality ))/20 ))
    end
  else
    if plant and plant.Quality and plant.Quality > 80 then
      xPlayer.addInventoryItem('meth100g', math.floor( math.random( math.floor(plant.Quality), math.floor(plant.Quality*2) ) ) )
    elseif plant.Quality then
      xPlayer.addInventoryItem('meth100g', math.floor( math.random( math.floor(plant.Quality/2), math.floor(plant.Quality) ) ) )
    end
  end
end
-- SP ©| Discord : https://discord.gg/39mJqPU / https://discord.gg/3wwzfmf
function MFD:PlantCheck(identifier, plant, delete)
  if not plant or not identifier then return; end
  local data = MySQL.Sync.fetchAll('SELECT * FROM methplants WHERE plantid=@plantid',{['@plantid'] = plant.PlantID})
  if not delete then
    if not data or not data[1] then  
      MySQL.Async.execute('INSERT INTO methplants (owner, plantid, plant) VALUES (@owner, @id, @plant)',{['@owner'] = identifier,['@id'] = plant.PlantID, ['@plant'] = json.encode(plant)})
    else
      MySQL.Sync.execute('UPDATE methplants SET plant=@plant WHERE plantid=@plantid',{['@plant'] = json.encode(plant),['@plantid'] = plant.PlantID})
    end
  else
    if data and data[1] then
      MySQL.Async.execute('DELETE FROM methplants WHERE plantid=@plantid', {['@plantid'] = plant.PlantID})
    end
  end
end

function MFD:GetLoginData(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local data = MySQL.Sync.fetchAll('SELECT * FROM methplants WHERE owner=@owner',{['@owner'] = xPlayer.identifier})
  if not data or not data[1] then return false; end
  local aTab = {}
  for k = 1,#data,1 do
    local v = data[k]
    if v and v.plant then
      local data = json.decode(v.plant)
      table.insert(aTab,data)
    end
  end
  return aTab
end
-- SP ©| Discord : https://discord.gg/39mJqPU / https://discord.gg/3wwzfmf
function MFD:ItemTemplate()
  return {
       ["Type"] = "Water",
    ["Quality"] = 0.0,
  }
end

function MFD:PlantTemplate()
  return {
   ["Gender"] = "Female",
  ["Quality"] = 0.0,
   ["Growth"] = 0.0,
    ["Water"] = 20.0,
     ["Food"] = 20.0,
    ["Stage"] = 1,
  ["PlantID"] = math.random(math.random(999999,9999999),math.random(99999999,999999999))
  }
end
-- SP ©| Discord : https://discord.gg/39mJqPU / https://discord.gg/3wwzfmf
ESX.RegisterServerCallback('MF_DopeMeth:GetLoginData', function(source,cb) cb(MFD:GetLoginData(source)); end)
ESX.RegisterServerCallback('MF_DopeMeth:GetStartData', function(source,cb) while not MFD.dS do Citizen.Wait(0); end; cb(MFD.cS); end)
AddEventHandler('MF_DopeMeth:SyncPlant', function(plant,delete) MFD:SyncPlant(plant,delete); end)
AddEventHandler('playerConnected', function(...) MFD:DoLogin(source); end)
Citizen.CreateThread(function(...) MFD:Awake(...); end)

-- Maintenance Items
ESX.RegisterUsableItem('wateringcan', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('wateringcan').count > 0 then 
    xPlayer.removeInventoryItem('wateringcan', 1)

    local template = MFD:ItemTemplate()
    template.Type = "Water"
    template.Quality = 0.1

    TriggerClientEvent('MF_DopeMeth:UseItem',source,template)
  end
end)

ESX.RegisterUsableItem('purifiedwater', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('purifiedwater').count > 0 then 
    xPlayer.removeInventoryItem('purifiedwater', 1)

    local template = MFD:ItemTemplate()
    template.Type = "Water"
    template.Quality = 0.2

    TriggerClientEvent('MF_DopeMeth:UseItem',source,template)
  end
end)

ESX.RegisterUsableItem('lowgradefert', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('lowgradefert').count > 0 then 
    xPlayer.removeInventoryItem('lowgradefert', 1)

    local template = MFD:ItemTemplate()
    template.Type = "Food"
    template.Quality = 0.1

    TriggerClientEvent('MF_DopeMeth:UseItem',source,template)
  end
end)
-- SP ©| Discord : https://discord.gg/39mJqPU / https://discord.gg/3wwzfmf
ESX.RegisterUsableItem('ingredients', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('ingredients').count > 0 then 
    xPlayer.removeInventoryItem('ingredients', 1)

    local template = MFD:ItemTemplate()
    template.Type = "Food"
    template.Quality = 0.2

    TriggerClientEvent('MF_DopeMeth:UseItem',source,template)
  end
end)

-- Seed Items
ESX.RegisterUsableItem('lowgrademaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('lowgrademaleseed').count > 0 and xPlayer.getInventoryItem('table').count > 0 then 
    xPlayer.removeInventoryItem('lowgrademaleseed', 1)
    xPlayer.removeInventoryItem('table', 1)

    local template = MFD:PlantTemplate()
    template.Gender = "Male"
    template.Quality = math.random(1,100)/10
    template.Food =  math.random(100,200)/10
    template.Water = math.random(100,200)/10

    TriggerClientEvent('MF_DopeMeth:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('highgrademaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('highgrademaleseed').count > 0 and xPlayer.getInventoryItem('table').count > 0 then
    xPlayer.removeInventoryItem('highgrademaleseed', 1)
    xPlayer.removeInventoryItem('table', 1)

    local template = MFD:PlantTemplate()
    template.Gender = "Male"
    template.Quality = 0.2
    template.Quality = math.random(200,500)/10
    template.Food =  math.random(200,400)/10
    template.Water = math.random(200,400)/10

    TriggerClientEvent('MF_DopeMeth:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('preparationmeth', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('preparationmeth').count > 0 and xPlayer.getInventoryItem('table').count > 0 then
    xPlayer.removeInventoryItem('preparationmeth', 1)
    xPlayer.removeInventoryItem('table', 1)

    local template = MFD:PlantTemplate()
    template.Gender = "Female"
    template.Quality = 0.1
    template.Quality = math.random(1,100)/10
    template.Food =  math.random(100,200)/10
    template.Water = math.random(100,200)/10

    TriggerClientEvent('MF_DopeMeth:UseSeed',source,template)
  end
end)

ESX.RegisterUsableItem('dopebag', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  local canUse = false
  local msg = ''
  if xPlayer.getInventoryItem('trimmedweed').count >= MFD.WeedPerBag and xPlayer.getInventoryItem('drugscales').count > 0 then
    xPlayer.removeInventoryItem('dopebag', 1)
    xPlayer.removeInventoryItem('trimmedweed', MFD.WeedPerBag)
    xPlayer.addInventoryItem('bagofdope', 1)
    canUse = true
    msg = "You put "..MFD.WeedPerBag.." trimmed weed into the ziplock bag"
  elseif xPlayer.getInventoryItem('trimmedweed').count > 0 then
    msg = "You need scales to weigh the bag up correctly."
  else
    msg = "You don't have enough trimmed weed to do this."
  end
  TriggerClientEvent('MF_DopeMeth:UseBag', source, canUse, msg)
end)
-- SP ©| Discord : https://discord.gg/39mJqPU / https://discord.gg/3wwzfmf
ESX.RegisterUsableItem('highgradefemaleseed', function(source)
  local xPlayer = ESX.GetPlayerFromId(source)
  while not xPlayer do Citizen.Wait(0); ESX.GetPlayerFromId(source); end
  if xPlayer.getInventoryItem('highgradefemaleseed').count > 0 and xPlayer.getInventoryItem('table').count > 0 then
    xPlayer.removeInventoryItem('highgradefemaleseed', 1)
    xPlayer.removeInventoryItem('table', 1)

    local template = MFD:PlantTemplate()
    template.Gender = "Female"
    template.Quality = 0.2
    template.Quality = math.random(200,500)/10
    template.Food =  math.random(200,400)/10
    template.Water = math.random(200,400)/10

    TriggerClientEvent('MF_DopeMeth:UseSeed',source,template)
  end
end)
-- SP ©| Discord : https://discord.gg/39mJqPU / https://discord.gg/3wwzfmf