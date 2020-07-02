ESX = nil

local cachedData = {}

ESX.TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterCommand(Config.Command) {
    TryToFish();
}

ESX.RegisterUsableItem(
    Config.FishingItems["rod"]["name"],
    function(source)
        ESX.TriggerClientEvent("james_fishing:tryToFish", source)
    end
)

ESX.RegisterServerCallback(
    "james_fishing:receiveFish",
    function(source, callback)
        local player = ESX.GetPlayerFromId(source)

        if not player then
            return callback(false)
        end

        player.removeInventoryItem(Config.FishingItems["bait"]["name"], 1)
        player.addInventoryItem(Config.FishingItems["fish"]["name"], 1)

        callback(true)
    end
)

ESX.RegisterServerCallback(
    "james_fishing:sellFish",
    function(source, callback)
        local player = ESX.GetPlayerFromId(source)

        if not player then
            return callback(false)
        end

        local fishItem = Config.FishingItems["fish"]

        local fishCount = player.getInventoryItem(fishItem["name"])["count"]
        local fishPrice = fishItem["price"]
        local bonus = 0
        local fishTotal = (fishCount * fishPrice)

        if fishCount > 0 then
            function GetRandomBonus()
                math.randomseed(os.time())
                return math.random(0, 50)
            end

            for i = 1, fishCount do
                bonus = bonus + GetRandomBonus()
            end

            TriggerClientEvent(
                "notification",
                "You sold " ..
                    fishCount .. " " .. fishItem["name"] .. " for $" .. fishTotal .. " with a bonus of $" .. bonus .. "",
                3
            )
            player.addMoney(fishTotal + bonus)
            player.removeInventoryItem(fishItem["name"], fishCount)

            callback(true, fishCount, fishTotal, bonus)
        else
            callback(false)
        end
    end
)
