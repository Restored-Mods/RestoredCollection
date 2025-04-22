local runData = {
	HasMorphedKeepersRope = false,
	LastPillUsed = -1,
	HPUpDownEnemies = {},
	PacifistLevels = {},
	HiddenItemManager = {},
	IllusionData = {},
}

local floorData = {
	MonsterTeleTable = {},
}

RestoredCollection.SaveManager.Utility.AddDefaultRunData(RestoredCollection.SaveManager.DefaultSaveKeys.GLOBAL, runData)
RestoredCollection.SaveManager.Utility.AddDefaultFloorData(
	RestoredCollection.SaveManager.DefaultSaveKeys.GLOBAL,
	floorData
)

RestoredCollection:AddDefaultFileSave("DisabledItems", {})
RestoredCollection:AddDefaultFileSave("MaxsHead", 1)

RestoredCollection.Game = Game()
RestoredCollection.Level = function()
	return RestoredCollection.Game:GetLevel()
end
RestoredCollection.Room = function()
	return RestoredCollection.Game:GetRoom()
end

RestoredCollection.RNG = RNG()

RestoredCollection:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, function()
	RestoredCollection.RNG:SetSeed(RestoredCollection.Game:GetSeeds():GetStartSeed())
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

RestoredCollection:AddCallback(RestoredCollection.SaveManager.SaveCallbacks.POST_DATA_LOAD, function(_, data, luaMod)
	if not luaMod then
		if not REPENTOGON then
			RestoredCollection.HiddenItemManager:LoadData(data.game.run.HiddenItemManager)
		end
        IllusionMod.LoadSaveData(data.game.run.IllusionData)
	end
end)
