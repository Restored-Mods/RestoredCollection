function RestoredCollection:GameSave()
	return RestoredCollection.SaveManager.GetPersistentSave()
end

function RestoredCollection:RunSave(ent, noHourglass, allowSoulSave)
    return RestoredCollection.SaveManager.GetRunSave(ent, noHourglass, allowSoulSave)
end

function RestoredCollection:FloorSave(ent, noHourglass, allowSoulSave)
    return RestoredCollection.SaveManager.GetFloorSave(ent, noHourglass, allowSoulSave)
end

function RestoredCollection:RoomSave(ent, noHourglass, gridIndex, allowSoulSave)
    return RestoredCollection.SaveManager.GetRoomSave(ent, noHourglass, gridIndex, allowSoulSave)
end

function RestoredCollection:AddDefaultFileSave(key, value)
    RestoredCollection.SaveManager.DEFAULT_SAVE.file.other[key] = value
end

function RestoredCollection:GetDefaultFileSave(key)
    if RestoredCollection.SaveManager.Utility.IsDataInitialized() then
        return RestoredCollection.SaveManager.DEFAULT_SAVE.file.other[key]
    end
end