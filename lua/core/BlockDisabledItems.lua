local BlockDisabledItems = {}


function BlockDisabledItems:OnGameStart(isContinue)
    if isContinue then return end

    for disabledIndex, disabledItem in pairs(RestoredCollection:GetDefaultFileSave("DisabledItems")) do
        if RestoredCollection.Enums.CollectibleType[disabledIndex] then
            RestoredCollection.ItemPool:RemoveCollectible(RestoredCollection.Enums.CollectibleType[disabledIndex])
        end
    end
    for indexTrinket, disabledTrinket in pairs(RestoredCollection:GetDefaultFileSave("DisabledTrinkets")) do
        if RestoredCollection.Enums.TrinketType[indexTrinket] then
            RestoredCollection.ItemPool:RemoveTrinket(RestoredCollection.Enums.TrinketType[indexTrinket])
        end
    end
end
RestoredCollection:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, BlockDisabledItems.OnGameStart)


local isDisablingItem = false

function BlockDisabledItems:PostGetCollectible(selectedItem, poolType, decrease, seed)
    if isDisablingItem then return end

    local isDisabledItem = false

    for disabledIndex, disabledItem in ipairs(RestoredCollection:GetDefaultFileSave("DisabledItems")) do
        if selectedItem == RestoredCollection.Enums.CollectibleType[disabledIndex] then
            isDisabledItem = true
            break
        end
    end

    if not isDisabledItem then return end

    local rng = RNG()
    rng:SetSeed(seed, 35)

    isDisablingItem = true
    local newItem = RestoredCollection.ItemPool:GetCollectible(poolType, decrease, rng:Next() * 1000)
    isDisablingItem = false

    return newItem
end
RestoredCollection:AddCallback(ModCallbacks.MC_POST_GET_COLLECTIBLE, BlockDisabledItems.PostGetCollectible)

function BlockDisabledItems:PostGetTrinket(selectedTrinket, rng)
    if isDisablingItem then return end

    local isDisabledItem = false

    for disabledIndex, disabledItem in pairs(RestoredCollection:GetDefaultFileSave("DisabledTrinkets")) do
        if selectedTrinket == RestoredCollection.Enums.TrinketType[disabledIndex] then
            isDisabledItem = true
            break
        end
    end

    if not isDisabledItem then return end

    isDisablingItem = true
    local newItem = RestoredCollection.ItemPool:GetTrinket()
    isDisablingItem = false

    return newItem
end
RestoredCollection:AddCallback(ModCallbacks.MC_GET_TRINKET, BlockDisabledItems.PostGetTrinket)

local firstBlacklistTrinket = RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID_TC
local lastBlacklistTrinket = RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID_TC

---@param trinket EntityPickup
function BlockDisabledItems:RerollDisabledTrinkets(trinket)
    if trinket.SubType >= firstBlacklistTrinket and trinket.SubType <= lastBlacklistTrinket then
        for disabledIndex, disabledItem in pairs(RestoredCollection:GetDefaultFileSave("DisabledTrinkets")) do
            if trinket.SubType == RestoredCollection.Enums.TrinketType[disabledIndex] then
                if trinket:GetSprite():IsPlaying("Appear") or trinket:IsShopItem() then
                    trinket:Morph(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_TRINKET, 0, true, true)
                else
                    trinket:Remove()
                end
                break
            end
        end
    end
end
RestoredCollection:AddCallback(ModCallbacks.MC_POST_PICKUP_UPDATE, BlockDisabledItems.RerollDisabledTrinkets, PickupVariant.PICKUP_TRINKET)