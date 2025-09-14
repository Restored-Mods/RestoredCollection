local LuckySeven = {}
local Helpers = RestoredCollection.Helpers
local luckySevenRootPath = "lua.items.passive.LuckySeven.lucky_seven_scripts."
--[[]]
--Main LuckySeven code
include(luckySevenRootPath.."HUDSparks")
include(luckySevenRootPath.."LuckySevenTears")
include(luckySevenRootPath.."LuckySevenLasers")
include(luckySevenRootPath.."SlotsManager")
include(luckySevenRootPath.."LuckySevenBoneSwing")
include(luckySevenRootPath.."LuckySevenLudovico")

RestoredCollection.LuckySevenRegularSlot = include(luckySevenRootPath.."special_slots.RegularSlot")
RestoredCollection.LuckySevenSpecialSlots = {
    include(luckySevenRootPath.."special_slots.BloodDonationMachine"),
    include(luckySevenRootPath.."special_slots.DonationMachine"),
    include(luckySevenRootPath.."special_slots.FortuneTellingMachine"),
    include(luckySevenRootPath.."special_slots.Electrifier"),
    include(luckySevenRootPath.."special_slots.CraneGame"),
}

if REPENTOGON then
    function LuckySeven:Coins(collectible, charge, firstTime, slot, VarData, player)
        if firstTime and collectible == RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN then
            local room = Game():GetRoom()
            for _ = 1, 7, 1 do
                local spawningPos = room:FindFreePickupSpawnPosition(player.Position, 1, true)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, spawningPos, Vector.Zero, player)
            end
        end
    end
    RestoredCollection:AddCallback(ModCallbacks.MC_POST_ADD_COLLECTIBLE, LuckySeven.Coins)
else
    ---@type Entity[]
    RestoredCollection.LuckySevenSlotsInRoom = {}
    function LuckySeven:OnPlayerInit(player)
		local data = Helpers.GetData(player)
		data.LuckySevenCount = player:GetCollectibleNum(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN)
	end
	RestoredCollection:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, LuckySeven.OnPlayerInit)

	function LuckySeven:Coins(player, cache)
		if player.Parent ~= nil then return end
		if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
			player = player:GetMainTwin()
		end
		local data = Helpers.GetData(player)
		if data.LuckySevenCount and player:GetCollectibleNum(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN) > data.LuckySevenCount then
			local room = Game():GetRoom()
            for _ = 1, 7, 1 do
                local spawningPos = room:FindFreePickupSpawnPosition(player.Position, 1, true)
                Isaac.Spawn(EntityType.ENTITY_PICKUP, PickupVariant.PICKUP_COIN, CoinSubType.COIN_PENNY, spawningPos, Vector.Zero, player)
            end
		end
		data.LuckySevenCount = player:GetCollectibleNum(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN)
	end
	RestoredCollection:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LuckySeven.Coins, CacheFlag.CACHE_TEARFLAG)
end

---@param player EntityPlayer
function LuckySeven:OnCache(player)
    if player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN) then 
        player.Luck = player.Luck + 2 * player:GetCollectibleNum(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_LUCKY_SEVEN)
    end
end
RestoredCollection:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, LuckySeven.OnCache, CacheFlag.CACHE_LUCK)