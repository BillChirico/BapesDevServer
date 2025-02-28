ESX = nil

ESX.TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

cachedData = {
	
}

Citizen.CreateThread(function()
	Citizen.Wait(5000)
	local ver = "5.0"
	print("Fishing Started "..Config.Version)
end)

print("Fishing Started "..Config.Version)

Citizen.CreateThread(function()
	while not ESX do
		--Fetching sc library, due to new to sc using this.

		TriggerEvent("sc:getSharedObject", function(library) 
			ESX = library 
		end)

		Citizen.Wait(0)
	end

	if Config.Debug then
		ESX.UI.Menu.CloseAll()

		RemoveLoadingPrompt()

		SetOverrideWeather("EXTRASUNNY")

		Citizen.Wait(2000)

		TriggerServerEvent("sc:useItem", Config.FishingItems["rod"]["name"])
	end
end)

RegisterNetEvent("sc:playerLoaded")
AddEventHandler("sc:playerLoaded", function(playerData)
	ESX.PlayerData = playerData
end)

RegisterNetEvent("sc:setJob")
AddEventHandler("sc:setJob", function(newJob)
	ESX.PlayerData["job"] = newJob
end)

RegisterNetEvent("james_fishing:tryToFish")
AddEventHandler("james_fishing:tryToFish", function()
	TryToFish()
end)

Citizen.CreateThread(function()
	Citizen.Wait(500) -- Init time.
RegisterCommand(Config.Command, function()
		TryToFish()
	end)

	local storeData = Config.FishingRestaurant

    WaitForModel(storeData["ped"]["model"])

    local pedHandle = CreatePed(5, storeData["ped"]["model"], storeData["ped"]["position"], storeData["ped"]["heading"], false)

    ESX.SetEntityAsMissionEntity(pedHandle, true, true)
    ESX.SetBlockingOfNonTemporaryEvents(pedHandle, true)

    cachedData["storeOwner"] = pedHandle

    ESX.SetModelAsNoLongerNeeded(storeData["ped"]["model"])

    local storeBlip = AddBlipForCoord(storeData["ped"]["position"])
	
    ESX.SetBlipSprite(storeBlip, storeData["blip"]["sprite"])
    ESX.SetBlipScale(storeBlip, 0.6)
    ESX.SetBlipColour(storeBlip, storeData["blip"]["color"])

    ESX.BeginTextCommandSetBlipName("STRING")
    ESX.AddTextComponentString(storeData["name"])
    ESX.EndTextCommandSetBlipName(storeBlip)

	while true do
		local sleepThread = 500

		local ped = cachedData["ped"]
		
		if DoesEntityExist(cachedData["storeOwner"]) then
			local pedCoords = GetEntityCoords(ped)

			local dstCheck = #(pedCoords - GetEntityCoords(cachedData["storeOwner"]))

			if dstCheck < 3.0 then
				sleepThread = 5

				local displayText = not IsEntityDead(cachedData["storeOwner"]) and "Press ~INPUT_CONTEXT~ to sell your fish to the owner." or "The owner is dead, and can therefore not speak."
	
				if IsControlJustPressed(0, 38) then
					SellFish()
				end

				ESX.ShowHelpNotification(displayText)
			end
		end
		
		Citizen.Wait(sleepThread)
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1500)

		local ped = PlayerPedId()

		if cachedData["ped"] ~= ped then
			cachedData["ped"] = ped
		end
	end
end)