local runData = {
	HasMorphedKeepersRope = false,
	LastPillUsed = -1,
	HPUpDownEnemies = {},
	PacifistLevels = {},
	HiddenItemManager = {},
}

local floorData = {
	MonsterTeleTable = {},
}

RestoredCollection.SaveManager.Utility.AddDefaultRunData(RestoredCollection.SaveManager.DefaultSaveKeys.GLOBAL, runData)
RestoredCollection.SaveManager.Utility.AddDefaultFloorData(
	RestoredCollection.SaveManager.DefaultSaveKeys.GLOBAL,
	floorData
)

RestoredCollection.Game = Game()
RestoredCollection.Level = function()
	return RestoredCollection.Game:GetLevel()
end
RestoredCollection.Room = function()
	return RestoredCollection.Game:GetRoom()
end
RestoredCollection.ItemPool = RestoredCollection.Game:GetItemPool()
RestoredCollection.HUD = RestoredCollection.Game:GetHUD()
RestoredCollection.RNG = RNG()

RestoredCollection:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	RestoredCollection.RNG:SetSeed(RestoredCollection.Game:GetSeeds():GetStartSeed(), 35)
end)

RestoredCollection:AddCallback(RestoredCollection.SaveManager.SaveCallbacks.PRE_DATA_SAVE, function(_, data)
	local newData = {
		game = {
			run = {
				IllusionData = IllusionMod.GetSaveData(),
			},
		},
	}
	if not REPENTOGON then
		newData.game.run.HiddenItemManager = RestoredCollection.HiddenItemManager:GetSaveData()
	end
	return RestoredCollection.SaveManager.Utility.PatchSaveFile(newData, data)
end)

RestoredCollection:AddCallback(RestoredCollection.SaveManager.SaveCallbacks.PRE_DATA_LOAD, function(_, data, luaMod)
	if not luaMod then
		local settings = {
			["DisabledItems"] = {},
			["DisabledTrinkets"] = {},
			["MaxsHead"] = 1,
			["IllusionCanPlaceBomb"] = IllusionMod.CanPlaceBomb,
			["IllusionPerfectIllusion"] = IllusionMod.PerfectIllusion,
		}
		for k, v in pairs(settings) do
			if data.file.other[k] == nil then
				data.file.other[k] = v
			end
		end
		return data
	end
end)

RestoredCollection:AddCallback(RestoredCollection.SaveManager.SaveCallbacks.POST_DATA_LOAD, function(_, data, luaMod)
	if not luaMod then
		if not REPENTOGON then
			RestoredCollection.HiddenItemManager:LoadData(data.game.run.HiddenItemManager)
		else
			local itemConfig = Isaac.GetItemConfig()
			for disabledSaveString, data in pairs({
				["DisabledItems"] = {
					Func = itemConfig.GetCollectible,
					LookupTable = RestoredCollection.Enums.CollectibleType,
				},
				["DisabledTrinkets"] = { Func = itemConfig.GetTrinket, LookupTable = RestoredCollection.Enums.TrinketType },
			}) do
				for enum, item in pairs(data.LookupTable) do
					local conf = data.Func(itemConfig, item)
					local disabledTab = RestoredCollection:GetDefaultFileSave(disabledSaveString)
					if disabledTab[enum] ~= nil then
						conf.Tags = conf.Tags | ItemConfig.TAG_NO_EDEN
					else
						conf.Tags = conf.Tags & ~ItemConfig.TAG_NO_EDEN
					end
				end
			end
		end
		IllusionMod.LoadSaveData(data.game.run.IllusionData)
		IllusionMod.CanPlaceBomb = data.file.other.IllusionCanPlaceBomb
		IllusionMod.PerfectIllusion = data.file.other.IllusionPerfectIllusion
	end
end)
