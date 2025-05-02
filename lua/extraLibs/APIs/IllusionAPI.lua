local localversion = 1.1
local game = Game()
local hud = game:GetHUD()
local sfx = SFXManager()

local function load(prevData)
	IllusionMod = RegisterMod("Illusion API", 1)
	IllusionMod.Version = localversion
    IllusionMod.Loaded = false
	IllusionMod.CanPlaceBomb = false
	IllusionMod.PerfectIllusion = false
	local IllusionCallbacks = {}
	local EntityData = {}

	local TransformationItems = {
		[PlayerForm.PLAYERFORM_DRUGS] = Isaac.GetItemIdByName("Spun transform"),
		[PlayerForm.PLAYERFORM_MOM] = Isaac.GetItemIdByName("Mom transform"),
		[PlayerForm.PLAYERFORM_GUPPY] = Isaac.GetItemIdByName("Guppy transform"),
		[PlayerForm.PLAYERFORM_LORD_OF_THE_FLIES] = Isaac.GetItemIdByName("Fly transform"),
		[PlayerForm.PLAYERFORM_BOB] = Isaac.GetItemIdByName("Bob transform"),
		[PlayerForm.PLAYERFORM_MUSHROOM] = Isaac.GetItemIdByName("Mushroom transform"),
		[PlayerForm.PLAYERFORM_BABY] = Isaac.GetItemIdByName("Baby transform"),
		[PlayerForm.PLAYERFORM_ANGEL] = Isaac.GetItemIdByName("Angel transform"),
		[PlayerForm.PLAYERFORM_EVIL_ANGEL] = Isaac.GetItemIdByName("Devil transform"),
		[PlayerForm.PLAYERFORM_POOP] = Isaac.GetItemIdByName("Poop transform"),
		[PlayerForm.PLAYERFORM_BOOK_WORM] = Isaac.GetItemIdByName("Book transform"),
		[PlayerForm.PLAYERFORM_SPIDERBABY] = Isaac.GetItemIdByName("Spider transform"),
	}
	
	local ForbiddenItems = {
		CollectibleType.COLLECTIBLE_1UP,
		CollectibleType.COLLECTIBLE_DEAD_CAT,
		CollectibleType.COLLECTIBLE_INNER_CHILD,
		CollectibleType.COLLECTIBLE_GUPPYS_COLLAR,
		CollectibleType.COLLECTIBLE_LAZARUS_RAGS,
		CollectibleType.COLLECTIBLE_ANKH,
		CollectibleType.COLLECTIBLE_JUDAS_SHADOW,
		CollectibleType.COLLECTIBLE_STRAW_MAN
	}
	
	local ForbiddenTrinkets = {
		TrinketType.TRINKET_MISSING_POSTER,
		TrinketType.TRINKET_BROKEN_ANKH
	}
	
	local ForbiddenPCombos = {
		{PlayerType = PlayerType.PLAYER_THELOST_B, Item = CollectibleType.COLLECTIBLE_BIRTHRIGHT},
	}

	local ForbiddenCharacters = {

	}

	if prevData ~= nil then
		TransformationItems = prevData.TransformationItems or TransformationItems
		ForbiddenItems = prevData.ForbiddenItems or ForbiddenItems
		ForbiddenTrinkets = prevData.ForbiddenTrinkets or ForbiddenTrinkets
		ForbiddenPCombos = prevData.ForbiddenPCombos or ForbiddenPCombos
		EntityData = prevData.EntityData
		IllusionMod.CanPlaceBomb = prevData.CanPlaceBomb or false
		IllusionMod.PerfectIllusion = prevData.PerfectIllusion or false
	end
	
	local function BlackList(collectible)
		for _,i in ipairs(ForbiddenItems) do
			if i == collectible then
				return true
			end
		end
		return false
	end
	
	local function BlackListTrinket(trinket)
		for _,i in ipairs(ForbiddenTrinkets) do
			if i == trinket then
				return true
			end
		end
		return false
	end
	
	local function CanBeRevived(pType,withItem)
		for _,v in ipairs(ForbiddenPCombos) do
			if v.PlayerType == pType and v.Item == withItem then
				return true
			end
		end
		return false
	end

	local function ChangeCharacter(pType)
		for _,v in ipairs(ForbiddenCharacters) do
			if v.PlayerType and v.PlayerType == pType then
				if v.PlayerTypeToChange then
					return v.PlayerTypeToChange
				end
			end
		end
		return pType
	end
	
	---@param player EntityPlayer
	---@param illusionPlayer EntityPlayer
	---@param playerType PlayerType
	local function AddItemsToIllusion(player, illusionPlayer, playerType)
		if REPENTOGON then
			local history = player:GetHistory():GetCollectiblesHistory()
			for index, item in ipairs(history) do
				if not item:IsTrinket() then
					local id = item:GetItemID()
					if not BlackList(id) and not CanBeRevived(playerType, id) then
						local itemCollectible = Isaac.GetItemConfig():GetCollectible(id)
						if not illusionPlayer:HasCollectible(id) and player:HasCollectible(id) and
						itemCollectible.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST and 
						not itemCollectible:HasCustomTag("revive") and 
						not itemCollectible:HasCustomTag("reviveeffect") then
							if itemCollectible.Type ~= ItemType.ITEM_ACTIVE then
								for _ = 1, player:GetCollectibleNum(id) do
									illusionPlayer:AddCollectible(id, 0, false)
								end
							end
						end
					end
				end
			end
		else
			for i=1, Isaac.GetItemConfig():GetCollectibles().Size - 1 do
				if not BlackList(i) and not CanBeRevived(playerType, i) then
					local itemConfig = Isaac.GetItemConfig()
					local itemCollectible = itemConfig:GetCollectible(i)
					if itemCollectible then
						if not illusionPlayer:HasCollectible(i) and player:HasCollectible(i) and
						itemCollectible.Tags & ItemConfig.TAG_QUEST ~= ItemConfig.TAG_QUEST then
							if itemCollectible.Type ~= ItemType.ITEM_ACTIVE then
								for _ = 1, player:GetCollectibleNum(i) do
									illusionPlayer:AddCollectible(i, 0, false)
								end
							end
						end
					end
				end
			end
		end
	end
	
	---@param illusionPlayer EntityPlayer
	local function RemoveActiveItemsFromIllusion(illusionPlayer)
		for i = 2, 0, -1 do
			local c = illusionPlayer:GetActiveItem(i)
			if c > 0 then
				illusionPlayer:RemoveCollectible(c,false,i)
			end
		end
	end
	
	---@param player EntityPlayer
	---@param illusionPlayer EntityPlayer
	local function AddTrinketsToIllusion(player, illusionPlayer)
		if REPENTOGON then
			local history = player:GetHistory():GetCollectiblesHistory()
			for index, item in ipairs(history) do
				if item:IsTrinket() then
					local id = item:GetItemID()
					local itemTrinket = Isaac.GetItemConfig():GetTrinket(id)
					if not BlackListTrinket(id) and itemTrinket then
						if not illusionPlayer:HasTrinket(id) and player:HasTrinket(id) and
						not itemTrinket:HasCustomTag("revive") and 
						not itemTrinket:HasCustomTag("reviveeffect") then
							for _ = 1, player:GetTrinketMultiplier(id) do
								illusionPlayer:AddSmeltedTrinket(id, false)
							end
						end
					end
				end
			end
		else
			for i=1, Isaac.GetItemConfig():GetTrinkets().Size - 1 do
				if not BlackListTrinket(i) then
					local itemConfig = Isaac.GetItemConfig()
					local itemTrinket = itemConfig:GetTrinket(i)
					if itemTrinket then
						if not illusionPlayer:HasTrinket(i) and player:HasTrinket(i) then
							for _ = 1, player:GetTrinketMultiplier(i) do
								illusionPlayer:AddTrinket(i,false)
								illusionPlayer:UseActiveItem(CollectibleType.COLLECTIBLE_SMELTER,false)
							end
						end
					end
				end
			end
		end
	end
	
	local function AddTransformationsToIllusion(player, illusionPlayer)
		for transformation, transformationItem in pairs(TransformationItems) do
			if player:HasPlayerForm(transformation) and not illusionPlayer:HasPlayerForm(transformation) then
				if REPENTOGON then
					illusionPlayer:IncrementPlayerFormCounter(transformation, 3)
				else
					for _ = 1, 3, 1 do
						illusionPlayer:AddCollectible(transformationItem)
					end
				end
			end
		end
	end
	
	---@param illusionPlayer EntityPlayer
	local function SetIllusionHealth(illusionPlayer)
		illusionPlayer:AddMaxHearts(-illusionPlayer:GetMaxHearts())
		illusionPlayer:AddSoulHearts(-illusionPlayer:GetSoulHearts())
		illusionPlayer:AddBoneHearts(-illusionPlayer:GetBoneHearts())
		illusionPlayer:AddGoldenHearts(-illusionPlayer:GetGoldenHearts())
		illusionPlayer:AddEternalHearts(-illusionPlayer:GetEternalHearts())
		illusionPlayer:AddHearts(-illusionPlayer:GetHearts())
	
		if illusionPlayer:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN then
			illusionPlayer:AddBoneHearts(1)
		else
			illusionPlayer:AddMaxHearts(2)
		end
		
		illusionPlayer:AddHearts(2)
	end
	
	---@param illusionPlayer EntityPlayer
	local function SpawnIllusionPoof(illusionPlayer)
		local poof = Isaac.Spawn(
			EntityType.ENTITY_EFFECT,
			EffectVariant.POOF01,
			-1,
			illusionPlayer.Position,
			Vector.Zero,
			illusionPlayer
		)
	
		local sColor = poof:GetSprite().Color
		local color = Color(sColor.R, sColor.G, sColor.B, 0.7, 0.518, 0.15, 0.8)
		local sprite = poof:GetSprite()
		sprite.Color = color
	end

	function IllusionMod.AddForbiddenItem(i)
		table.insert(ForbiddenItems,i)
	end
	
	function IllusionMod.AddForbiddenTrinket(i)
		table.insert(ForbiddenTrinkets,i)
	end
	
	function IllusionMod.AddForbiddenCharItem(type, i)
		table.insert(ForbiddenPCombos,{PlayerType = type, Item = i})
	end

	function IllusionMod.AddForbiddenChar(type, changeType)
		table.insert(ForbiddenCharacters,{PlayerType = type, PlayerTypeToChange = changeType})
	end

	local function GetPlayerIndex(player)
		local id = 1
		if player:GetPlayerType() == PlayerType.PLAYER_LAZARUS2_B then
			id = 2
		end
		return player:GetCollectibleRNG(id):GetSeed()
	end

	function IllusionMod.GetData(entity)
		if entity then
			if entity:ToPlayer() then
				local player = entity:ToPlayer()
				if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
					player = player:GetOtherTwin()
				end
				if not player then return nil end
				local index = tostring(GetPlayerIndex(player))
				if not EntityData["PLAYER_"..index] then
					EntityData["PLAYER_"..index] = {}
				end
				return EntityData["PLAYER_"..index]
			elseif entity:ToFamiliar() then
				local index = tostring(entity:ToFamiliar().InitSeed)
				if not EntityData["FAMILIAR_"..index] then
					EntityData["FAMILIAR_"..index] = {}
				end
				return EntityData["FAMILIAR_"..index]
			end
		end
		return nil
	end

	function IllusionMod.RemoveData(entity)
		if entity then
			if entity:ToPlayer() then
				local player = entity:ToPlayer()
				if player:GetPlayerType() == PlayerType.PLAYER_THESOUL_B then
					player = player:GetOtherTwin()
				end
				if not player then return nil end
				local index = tostring(GetPlayerIndex(player))
				EntityData["PLAYER_"..index] = nil
			elseif entity:ToFamiliar() then
				local index = tostring(entity:ToFamiliar().InitSeed)
				EntityData["FAMILIAR_"..index] = nil
			end
		end
	end

	---@param player EntityPlayer
	---@param isIllusion boolean
	---@param addWisp CollectibleType | integer?
	---@return EntityPlayer?
	function IllusionMod:addIllusion(player, isIllusion, addWisp)

		local playerType = player:GetPlayerType()

		if playerType == PlayerType.PLAYER_JACOB then
			player = player:GetOtherTwin()
			playerType = PlayerType.PLAYER_ESAU
		elseif playerType == PlayerType.PLAYER_THESOUL_B then
			playerType = PlayerType.PLAYER_THEFORGOTTEN_B
		elseif playerType == PlayerType.PLAYER_THESOUL then
			playerType = PlayerType.PLAYER_THEFORGOTTEN
		end

		Isaac.ExecuteCommand("addplayer 15 " .. player.ControllerIndex)

		local newPlayerIndex = game:GetNumPlayers() - 1
		local illusionPlayer = Isaac.GetPlayer(newPlayerIndex)

		local data = IllusionMod.GetData(illusionPlayer)
		if not data then return nil end
		if playerType == PlayerType.PLAYER_LAZARUS_B or playerType == PlayerType.PLAYER_LAZARUS2_B then
			playerType = PlayerType.PLAYER_ISAAC
			local costume

			if playerType == PlayerType.PLAYER_LAZARUS_B then
				data.TaintedLazA = true
				costume = NullItemID.ID_LAZARUS_B
			else
				data.TaintedLazB = true
				costume = NullItemID.ID_LAZARUS2_B
			end

			illusionPlayer:AddNullCostume(costume)
		end
		playerType = ChangeCharacter(playerType)
		if (IllusionMod.PerfectIllusion	or playerType < 41) then
			illusionPlayer:ChangePlayerType(playerType)
		else
			illusionPlayer:ChangePlayerType(PlayerType.PLAYER_ISAAC)
		end
		if isIllusion then
			AddItemsToIllusion(player, illusionPlayer, playerType)

			RemoveActiveItemsFromIllusion(illusionPlayer)

			AddTrinketsToIllusion(player, illusionPlayer)

			AddTransformationsToIllusion(player, illusionPlayer)

			data.IsIllusion = true

			SetIllusionHealth(illusionPlayer)

			if playerType == PlayerType.PLAYER_THEFORGOTTEN_B then
				local twinData = IllusionMod.GetData(illusionPlayer:GetOtherTwin())
				if not twinData then return end

				twinData.IsIllusion = true
				illusionPlayer:GetOtherTwin().Parent = player:GetOtherTwin()
			end

			SpawnIllusionPoof(illusionPlayer)
		end

		if type(addWisp) == "number" then
			local wisp = player:AddWisp(addWisp, player.Position)
			local wispData = IllusionMod.GetData(wisp)

			wispData.isIllusion = true
			wispData.illusionId = illusionPlayer:GetCollectibleRNG(1):GetSeed()
			data.hasWisp = true
		end

		illusionPlayer:PlayExtraAnimation("Appear")
		illusionPlayer:AddCacheFlags(CacheFlag.CACHE_ALL)
		illusionPlayer:EvaluateItems()
		illusionPlayer.Parent = player
		hud:AssignPlayerHUDs()
		return illusionPlayer
	end

	function IllusionMod.GetTablesData()
		return {TransformationItems = TransformationItems, ForbiddenItems = ForbiddenItems, ForbiddenTrinkets = ForbiddenTrinkets, ForbiddenPCombos = ForbiddenPCombos, EntityData = EntityData, CanPlaceBomb = IllusionMod.CanPlaceBomb, PerfectIllusion = IllusionMod.PerfectIllusion}
	end

	function IllusionMod.GetSaveData()
		return EntityData
	end

	function IllusionMod.LoadSaveData(data)
		EntityData = type(data) == "table" and data or {}
	end

	local function AddCallback(callback, func, ...)
		table.insert(IllusionCallbacks, {Callback = callback, Function = func, Param = {...}})
	end

	local function AddPriorityCallback(callback, priority, func, ...)
		table.insert(IllusionCallbacks, {Callback = callback, Function = func, Priority = priority, Param = {...}})
	end

	function IllusionMod.UnloadCallbacks()
		for _, callback in pairs(IllusionCallbacks) do
			IllusionMod:RemoveCallback(callback.Callback, callback.Function)
		end
	end

	function IllusionMod.LoadCallbacks()
		for _, callback in pairs(IllusionCallbacks) do
			if callback.Priority ~= nil then
				IllusionMod:AddPriorityCallback(callback.Callback, callback.Priority, callback.Function, table.unpack(callback.Param))
			else
				IllusionMod:AddCallback(callback.Callback, callback.Function, table.unpack(callback.Param))
			end
		end
	end

	function IllusionMod.ReloadCallbacks()
		IllusionMod.UnloadCallbacks()
		IllusionMod.LoadCallbacks()
	end

	local function ModReset()
        IllusionMod.Loaded = false
    end
    IllusionMod:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, ModReset)


	function IllusionMod.KillIllusion(p)
		if IllusionMod.GetData(p).IsIllusion then
			p:GetSprite():SetLastFrame()
			p:ChangePlayerType(PlayerType.PLAYER_THELOST)
			local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, p.Position, Vector.Zero, p)
			local sColor = poof:GetSprite().Color
			local color = Color(sColor.R, sColor.G, sColor.B, 0.7, 0.518, 0.15, 0.8)
			local s = poof:GetSprite()
			s.Color = color
			sfx:Play(SoundEffect.SOUND_BLACK_POOF)
			
			--[[p:AddMaxHearts(-p:GetMaxHearts())
			p:AddSoulHearts(-p:GetSoulHearts())
			p:AddBoneHearts(-p:GetBoneHearts())
			p:AddGoldenHearts(-p:GetGoldenHearts())
			p:AddEternalHearts(-p:GetEternalHearts())
			p:AddHearts(-p:GetHearts())]]
			p:Die()
		end
	end
	
	local function ModdedDeathCheck(p)
		local offset = (p:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN or p:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B) and Vector(30 * p.SpriteScale.X,0) or Vector.Zero
		if sussydeath then
			offset = Vector.Zero
		end
		return offset
	end
	
	
	---@param p EntityPlayer
	local function UpdateClones(_, p)
		local data = IllusionMod.GetData(p)
		if not data then return end
		if data.IsIllusion then
			p:GetData().Died = true -- Gruesome death mod check to avoid crash
			if p:IsDead()  then
				--p.Visible = false
				if p:GetPlayerType() ~= PlayerType.PLAYER_THELOST and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B 
				and p:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B then
					p:GetSprite():SetLayerFrame(PlayerSpriteLayer.SPRITE_GHOST,0)
				end
				
				p:GetSprite():SetLastFrame()
				
				sfx:Stop(SoundEffect.SOUND_ISAACDIES)
				
				if p:GetPlayerType() ~= PlayerType.PLAYER_THELOST and p:GetPlayerType() ~= PlayerType.PLAYER_THELOST_B and
				p:GetPlayerType() ~= PlayerType.PLAYER_THESOUL and p:GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B  and p:GetPlayerType() ~= PlayerType.PLAYER_THEFORGOTTEN_B
				and not p:GetEffects():HasNullEffect(NullItemID.ID_LOST_CURSE) then
					p:ChangePlayerType(PlayerType.PLAYER_THELOST)
					local offset = ModdedDeathCheck(p)
					
					if not SMW_Death then
						local poof = Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, p.Position + offset, Vector.Zero, p)
						local sColor = poof:GetSprite().Color
						local color = Color(sColor.R, sColor.G, sColor.B, 0.7, 0.518, 0.15, 0.8)
						local s = poof:GetSprite()
						s.Color = color
						sfx:Play(SoundEffect.SOUND_BLACK_POOF)
					end
				end
				
			end
			if not p:IsDead() then
				if p.Parent and (not p.Parent:Exists() or p.Parent:IsDead()) then
					IllusionMod.KillIllusion(p)
				end
			end
			p:GetEffects():RemoveCollectibleEffect(CollectibleType.COLLECTIBLE_HOLY_MANTLE)
		end
	end
	AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, UpdateClones)
	
	local function CloneRoomUpdate()
		for i = 0, game:GetNumPlayers()-1 do
			local p = Isaac.GetPlayer(i)
			local data = IllusionMod.GetData(p)
			if not data then return end
			if data.IsIllusion and p:IsDead() then
				p:GetSprite():SetLastFrame()
				p:ChangePlayerType(PlayerType.PLAYER_THELOST)
				Isaac.Spawn(EntityType.ENTITY_EFFECT, EffectVariant.POOF01, -1, p.Position, Vector.Zero, p)
			end
		end
	end
	AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CloneRoomUpdate)
	
		---@param p EntityPlayer
	local function CloneColor(_, p, _)
		local d = IllusionMod.GetData(p)
		if not d then return end
		if d.IsIllusion then
			--local color = Color(0.518, 0.22, 1, 0.45)
			local sColor = p:GetSprite().Color
			local color = Color(sColor.R, sColor.G, sColor.B, 0.45, 0.518, 0.15, 0.8)
			local s = p:GetSprite()
			s.Color = color
			if p:GetBoneHearts() > 0 and not (p:GetPlayerType() == PlayerType.PLAYER_THEFORGOTTEN or REPENTOGON and p:GetHealthType() == HealthType.BONE) then
				p:AddBoneHearts(-p:GetBoneHearts())
			end
			if p:GetGoldenHearts() > 0 then
				p:AddGoldenHearts(-p:GetGoldenHearts())
			end
			if p:GetEternalHearts() > 0 then
				p:AddEternalHearts(-p:GetEternalHearts())
			end
			if p.Parent and p.Parent:ToPlayer() and p.Parent:ToPlayer().MoveSpeed ~= p.MoveSpeed then
				p:AddCacheFlags(CacheFlag.CACHE_SPEED)
				p:EvaluateItems()
			end
		end
	end
	AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, CloneColor)
	
	local function Cache(_, player,cache)
		local d = IllusionMod.GetData(player)
		if not d then return end
		if d.IsIllusion then
			if d.TaintedLazA == true then
				if cache == CacheFlag.CACHE_RANGE then
					player.TearRange = player.TearRange - 80
				end
			elseif d.TaintedLazB == true then
				if cache == CacheFlag.CACHE_DAMAGE then
					player.Damage = player.Damage * 1.50
				elseif cache == CacheFlag.CACHE_FIREDELAY then
					player.MaxFireDelay = player.MaxFireDelay + 1
				elseif cache == CacheFlag.CACHE_LUCK then
					player.Luck = player.Luck - 2
				end
			end
			if cache == CacheFlag.CACHE_SPEED then
				local parent = player.Parent
				if parent and parent:ToPlayer() then
					player.MoveSpeed = parent:ToPlayer().MoveSpeed
				end
			end
		end
	end
	AddCallback(ModCallbacks.MC_EVALUATE_CACHE, Cache)
	
	local function preIllusionWhiteFlame(_, p, collider)
		if collider.Type == EntityType.ENTITY_FIREPLACE and collider.Variant == 4 then
			local d = IllusionMod.GetData(p)
			if not d then return end
			if d.IsIllusion then--or p.Parent then
				IllusionMod.KillIllusion(p)
			end
		end
	end
	AddCallback(ModCallbacks.MC_PRE_PLAYER_COLLISION, preIllusionWhiteFlame)
	
	local function prePickupCollision(_, pickup, collider)
		if collider and collider:ToPlayer() then
			local player = collider:ToPlayer()
			local d = IllusionMod.GetData(player)
			if not d then return end
			if d.IsIllusion then--or p.Parent then
				return true
			end
		end
	end
	AddPriorityCallback(ModCallbacks.MC_PRE_PICKUP_COLLISION, CallbackPriority.EARLY, prePickupCollision)

	local function onEntityTakeDamage(_, tookDamage)
		local data = IllusionMod.GetData(tookDamage)
		if not data then return end
		if data.IsIllusion then
			if data.hasWisp then return false end
			--doples always die in one hit, so the hud looks nicer. ideally i'd just get rid of the hud but that doesnt seem possible
			local player = tookDamage:ToPlayer()
			IllusionMod.KillIllusion(player)
			return false
		end
	end
	AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, onEntityTakeDamage, EntityType.ENTITY_PLAYER)
	
	local function AfterDeath(_, e)
		if e then
			if e:ToPlayer() and e:ToPlayer():GetPlayerType() ~= PlayerType.PLAYER_THESOUL_B
			or e:ToFamiliar() then
				local data = IllusionMod.GetData(e)
				if data and data.isIllusion then
					IllusionMod.RemoveData(e)
				end
			end
		end
	end
	AddCallback(ModCallbacks.MC_POST_ENTITY_REMOVE, AfterDeath)
	
	local function DarkEsau(_, e)
		if e.SpawnerEntity and e.SpawnerEntity:ToPlayer() then
			local p = e.SpawnerEntity:ToPlayer()
			local d = IllusionMod.GetData(p)
			if not d then return end
			if d.IsIllusion then
				local s = e:GetSprite().Color
				local color = Color(s.R, s.G, s.B, 0.45,0.518, 0.15, 0.8)
				local s = e:GetSprite()
				s.Color = color
			end
		end
	end
	AddCallback(ModCallbacks.MC_POST_NPC_RENDER, DarkEsau, EntityType.ENTITY_DARK_ESAU)
	
	local function Familiar(_, e)
		if e.SpawnerEntity and e.SpawnerEntity:ToPlayer() then
			local p = e.SpawnerEntity:ToPlayer()
			local d = IllusionMod.GetData(p)
			if not d then return end
			if d.IsIllusion then
				local s = e:GetSprite()
				s.Color = Color(s.Color.R, s.Color.G, s.Color.B, 0.45,0.518, 0.15, 0.8)
			end
		end
	end
	AddCallback(ModCallbacks.MC_POST_FAMILIAR_RENDER, Familiar)
	
	local function Knife(k)
		if k.SpawnerEntity and k.SpawnerEntity:ToPlayer() then
			local p = k.SpawnerEntity:ToPlayer()
			local d = IllusionMod.GetData(p)
			if not d then return end
			if d.IsIllusion then
				local s = k:GetSprite()
				s.Color = Color(s.Color.R, s.Color.G, s.Color.B, 0.45,0.518, 0.15, 0.8)
			end
		end
	end
	AddCallback(ModCallbacks.MC_POST_KNIFE_RENDER, Knife)
	
	local function ClonesControls(_, entity,hook,action)
		if entity ~= nil and entity.Type == EntityType.ENTITY_PLAYER and not IllusionMod.CanPlaceBomb then
			local p = entity:ToPlayer()
			local d = IllusionMod.GetData(p)
			if not d then return end
			if d.IsIllusion then
				if (hook == InputHook.GET_ACTION_VALUE or hook == InputHook.IS_ACTION_PRESSED) and p:GetSprite():IsPlaying("Appear") then
					return hook == InputHook.GET_ACTION_VALUE and 0 or false
				end
				if hook == InputHook.IS_ACTION_TRIGGERED and (action == ButtonAction.ACTION_BOMB or action == ButtonAction.ACTION_PILLCARD or
				action == ButtonAction.ACTION_ITEM or p:GetSprite():IsPlaying("Appear")) then
					return false
				end
			end
		end
	end
	AddCallback(ModCallbacks.MC_INPUT_ACTION, ClonesControls)

	local function Load(_, isLoading)
		if not isLoading then
			EntityData = {}
		end
	end
	AddCallback(ModCallbacks.MC_POST_GAME_STARTED, Load)

	if RedBaby then
		IllusionMod.AddForbiddenChar(RedBaby.enums.PlayerType.RED_BABY_A, PlayerType.PLAYER_BLUEBABY)
		IllusionMod.AddForbiddenItem(RedBaby.enums.CollectibleType.REDBABY_HEART)
	end

	print("[".. IllusionMod.Name .."]", "is loaded. Version "..IllusionMod.Version)
	IllusionMod.Loaded = true
	IllusionMod.LoadCallbacks()
end

if IllusionMod then
	if IllusionMod.Version < localversion or not IllusionMod.Loaded then
		if not IllusionMod.Loaded then
			print("Reloading [".. IllusionMod.Name .."]")
		else
			print("[".. IllusionMod.Name .."]", " found old script V" .. IllusionMod.Version .. ", found new script V" .. localversion .. ". replacing...")
		end
		local data = IllusionMod.GetTablesData()
		IllusionMod.UnloadCallbacks()
		IllusionMod = nil
		load(data)
	end
elseif not IllusionMod then
	load()
end