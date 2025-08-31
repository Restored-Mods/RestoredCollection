local callback = REPENTOGON and ModCallbacks.MC_POST_MODS_LOADED or ModCallbacks.MC_POST_GAME_STARTED
local loaded = false
RestoredCollection:AddCallback(callback, function ()
    if not FiendFolio or loaded then
        return
    end
    local referenceItems = { --Code refferenced from https://steamcommunity.com/sharedfiles/filedetails/?id=3281491787&searchtext=d.edith--
        Passives = {
            { ID = RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BLANK_BOMBS,    Reference = "Enter the Gungeon" },
        },
        Trinkets = {
            { ID = RestoredCollection.Enums.TrinketType.TRINKET_GAME_SQUID_TC,         Reference = "Florian Himsl" },
        },
    }
    for i = 1, #referenceItems.Passives do
        table.insert(FiendFolio.ReferenceItems.Passives, referenceItems.Passives[i])
    end
    for i = 1, #referenceItems.Trinkets do
        table.insert(FiendFolio.ReferenceItems.Trinkets, referenceItems.Trinkets[i])
    end
    FiendFolio:AddStackableItems({
			RestoredCollection.Enums.CollectibleType.COLLECTIBLE_CHECKED_MATE,
			RestoredCollection.Enums.CollectibleType.COLLECTIBLE_ANCIENT_REVELATION,
			RestoredCollection.Enums.CollectibleType.COLLECTIBLE_BETHS_HEART,
			RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MAXS_HEAD,
			RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MELTED_CANDLE,
			RestoredCollection.Enums.CollectibleType.COLLECTIBLE_TAMMYS_TAIL_TC,
		})
    loaded = true
end)