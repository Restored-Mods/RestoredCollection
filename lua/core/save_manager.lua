local SaveManager = {}
--Amazing save manager
local continue = false
local function IsContinue()
    local totPlayers = #Isaac.FindByType(EntityType.ENTITY_PLAYER)

    if totPlayers == 0 then
        if Game():GetFrameCount() == 0 then
            continue = false
        else
            local room = Game():GetRoom()
            local desc = Game():GetLevel():GetCurrentRoomDesc()

            if desc.SafeGridIndex == GridRooms.ROOM_GENESIS_IDX then
                if not room:IsFirstVisit() then
                    continue = true
                else
                    continue = false
                end
            else
                continue = true
            end
        end
    end

    return continue
end

function SaveManager:OnPlayerInit()
    if #Isaac.FindByType(EntityType.ENTITY_PLAYER) ~= 0 then return end

    local isContinue = IsContinue()

    if isContinue and RestoredCollection:HasData() then
        TSIL.SaveManager.LoadFromDisk()
        CustomHealthAPI.Library.LoadHealthFromBackup(TSIL.SaveManager.GetPersistentVariable(RestoredCollection, "CustomHealthAPISave"))
        RestoredCollection.HiddenItemManager:LoadData(TSIL.SaveManager.GetPersistentVariable(RestoredCollection, "HiddenItemMangerSave"))
    end
    for _, funct in ipairs(RestoredCollection.CallOnStart) do
        funct()
    end
end
RestoredCollection:AddCallback(ModCallbacks.MC_POST_PLAYER_INIT, SaveManager.OnPlayerInit)

local function SaveAll()
    if not TSIL.Stage.OnFirstFloor() then
        SaveManager:SaveData(true)
    end
end

function SaveManager:SaveData(isSaving)
    if isSaving then
        TSIL.SaveManager.LoadFromDisk()
        TSIL.SaveManager.SetPersistentVariable(RestoredCollection, "HiddenItemMangerSave", RestoredCollection.HiddenItemManager:GetSaveData())
        TSIL.SaveManager.SetPersistentVariable(RestoredCollection, "CustomHealthAPISave", CustomHealthAPI.Library.GetHealthBackup())
    end
    TSIL.SaveManager.SaveToDisk()
end
RestoredCollection:AddCallback(ModCallbacks.MC_PRE_GAME_EXIT, SaveManager.SaveData)
RestoredCollection:AddCallback(TSIL.Enums.CustomCallback.PRE_NEW_LEVEL, SaveAll)