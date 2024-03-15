local SafetyBombsMod = {}
local Helpers = require("lua.helpers.Helpers")


local SpecialSynergies = {
	[TearFlags.TEAR_STICKY] = function (player, entity)
		entity:AddSlowing(EntityRef(player), 10, 1, Color(1, 1, 1))
	end,

	[TearFlags.TEAR_BURN] = function (player, entity)
		entity:AddBurn(EntityRef(player), 10, player.Damage)
	end,

	[TearFlags.TEAR_POISON] = function (player, entity)
		entity:AddPoison(EntityRef(player), 10, player.Damage)
	end,

	[TearFlags.TEAR_BUTT_BOMB] = function (player, entity)
		entity:AddConfusion(EntityRef(player), 10, true)
	end,
}

function SafetyBombsMod:BombInit(bomb)
	local player = Helpers.GetPlayerFromTear(bomb)
	if player then
		local data = Helpers.GetData(bomb)
		if player:HasCollectible(RestoredItemsPack.Enums.CollectibleType.COLLECTIBLE_SAFETY_BOMBS) then
			if (bomb.Variant > BombVariant.BOMB_SUPERTROLL or bomb.Variant < BombVariant.BOMB_TROLL) then
				if bomb.Variant == 0 then
					bomb.Variant = RestoredItemsPack.Enums.BombVariant.BOMB_SAFETY
				end
			end
			data.isSafetyBomb = true
		elseif player:HasCollectible(CollectibleType.COLLECTIBLE_NANCY_BOMBS) and
		player:GetCollectibleRNG(CollectibleType.COLLECTIBLE_NANCY_BOMBS):RandomInt(100) < 10 then
			data.isSafetyBomb = true
		end
	end
end
RestoredItemsPack:AddCallback(ModCallbacks.MC_POST_BOMB_INIT, SafetyBombsMod.BombInit)

---@param bomb EntityBomb
function SafetyBombsMod:BombUpdate(bomb)
	local player = Helpers.GetPlayerFromTear(bomb)
	local data = Helpers.GetData(bomb)
	local fuseCD = REPENTOGON and bomb:GetExplosionCountdown() or 30
	local isBomber
	if player then
		if player:HasTrinket(TrinketType.TRINKET_SHORT_FUSE) then
			fuseCD = 2
		end
		isBomber = player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
	end

	if data.isSafetyBomb then
		
		if data.IsBlankBombInstaDetonating then
			return
		end

		local playBackSpeed = 0.4
		for _, entity in ipairs(Isaac.FindInRadius(bomb.Position, Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber) * bomb.RadiusMultiplier)) do
			if entity.Type == EntityType.ENTITY_PLAYER then
				local fuse = REPENTOGON and (fuseCD + 1) or fuseCD
				bomb:SetExplosionCountdown(fuse)
			elseif entity.Type == EntityType.ENTITY_BOMB then
				local selfPtr = GetPtrHash(bomb)
				local otherPtr = GetPtrHash(entity)

				if selfPtr ~= otherPtr then
					playBackSpeed = playBackSpeed + 0.1
				end
			end
		end
		if data.BombRadar then
			data.BombRadar.Sprite.PlaybackSpeed = playBackSpeed
		end

		local debuffs = {}
		for flag, funct in pairs(SpecialSynergies) do
			---@diagnostic disable-next-line: param-type-mismatch
			if bomb:HasTearFlags(flag) then
				debuffs[#debuffs+1] = funct
			end
		end

		if #debuffs == 0 then return end

		---@diagnostic disable-next-line: param-type-mismatch
		local bombRange = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage, bomb:HasTearFlags(TearFlags.TEAR_CROSS_BOMB))

		for _, entity in ipairs(Helpers.GetEnemies(false, true)) do
			if entity.Position:DistanceSquared(bomb.Position) <= bombRange ^ 2 then
				for _, funct in ipairs(debuffs) do
					funct(player, entity)
				end
			end
		end
	end
end
RestoredItemsPack:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, SafetyBombsMod.BombUpdate)


local function DoRenderRadar(bomb)
	local data = Helpers.GetData(bomb)
	local player = Helpers.GetPlayerFromTear(bomb)
	local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
	data.BombRadar.SafetyBombTrigger = false
	for i, p in ipairs(Isaac.FindInRadius(bomb.Position, Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber) * bomb.RadiusMultiplier, EntityPartition.PLAYER)) do
		data.BombRadar.SafetyBombTrigger = true
	end
	if not Game():IsPaused() then
		if data.BombRadar.SafetyBombTrigger then
			if data.BombRadar.SafetyBombTransparency < 1 then
				data.BombRadar.SafetyBombTransparency = data.BombRadar.SafetyBombTransparency + 0.05
			end
		elseif data.BombRadar.SafetyBombTransparency > 0 then
			data.BombRadar.SafetyBombTransparency = data.BombRadar.SafetyBombTransparency - 0.05
		end
	end
	if data.BombRadar.SafetyBombTransparency > 0 then
		if not Game():IsPaused() then
			data.BombRadar.Sprite:Update()
		end
		data.BombRadar.Sprite.Color = Color(1,1,1,data.BombRadar.SafetyBombTransparency)
		data.BombRadar.Sprite:Render(Game():GetRoom():WorldToScreenPosition(bomb.Position))
	elseif data.BombRadar.SafetyBombTransparency <= 0 then
		data.BombRadar = nil
	end
end

function SafetyBombsMod:BombRadar(bomb)
	if Game():GetRoom():GetRenderMode() == RenderMode.RENDER_WATER_REFLECT then return end
	local data = Helpers.GetData(bomb)
	
	if data.isSafetyBomb then
		if not data.BombRadar then
			local player = Helpers.GetPlayerFromTear(bomb)
			local isBomber = player and player:HasCollectible(CollectibleType.COLLECTIBLE_BOMBER_BOY)
			local mul = Helpers.GetBombRadiusFromDamage(bomb.ExplosionDamage,isBomber) / 75 * bomb.RadiusMultiplier
			data.BombRadar = {}
			data.BombRadar.Sprite = Sprite()
			data.BombRadar.Sprite:Load("gfx/safetybombsradar.anm2",true)
			data.BombRadar.Sprite:Play("Idle")
			data.BombRadar.Sprite.Scale = Vector(1.4*mul,1.4*mul)
			data.BombRadar.Sprite.PlaybackSpeed = 0.4
			data.BombRadar.SafetyBombTransparency = 0
			data.BombRadar.SafetyBombTrigger = false
		else
			DoRenderRadar(bomb)
		end
	end
end
RestoredItemsPack:AddCallback(ModCallbacks.MC_POST_BOMB_RENDER, SafetyBombsMod.BombRadar)