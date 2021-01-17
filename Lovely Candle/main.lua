local lovelyCandle = RegisterMod("Lovely Candle", 1)

-- Get the itemID and store it in a variable
lovelyCandle.COLLECTIBLE_LOVELY_CANDLE = Isaac.GetItemIdByName("Lovely Candle")

-- onUpdate func - no arguments passed to it by MC_POST_UPDATE
function lovelyCandle:onUpdate()
    --Start of run initialization
    if Game():GetFrameCount() == 1 then
        Isaac.DebugString("Starting new run - Lovely Candle Mod") -- logs to log.txt
        lovelyCandle.HasLovelyCandle = false
        -- comment the below line out to not spawn in the starting room
         Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COLLECTIBLE, lovelyCandle.COLLECTIBLE_LOVELY_CANDLE, Vector(320,300), Vector(0,0), nil)
    end

    --For 1 to the number of players, do something
    for playerNum = 1, Game():GetNumPlayers() do -- Go through the number of players in the game (in case there is 2+)
        local player = Game():GetPlayer(playerNum)

        if player:HasCollectible(lovelyCandle.COLLECTIBLE_LOVELY_CANDLE) then
            if not lovelyCandle.HasLovelyCandle then -- We have just picked up the item for the first time
                player:AddSoulHearts(2)
                lovelyCandle.HasLovelyCandle = true -- we have the lovely candle now, so set to true
            end

            for i, entity in pairs(Isaac.GetRoomEntities()) do
                if entity:IsVulnerableEnemy() and math.random(500) == 1 then -- 500 to 1 chance of being charmed
                    entity:AddCharmed(90) --charm the valid enemies for 3 seconds (90 frames at 30fps)
                end
            end
        end
    end
end

-- Callback function - lovelyCandle.onUpdate is called when there is a game update, provided by MC_POST_UPDATE
lovelyCandle:AddCallback(ModCallbacks.MC_POST_UPDATE, lovelyCandle.onUpdate) 