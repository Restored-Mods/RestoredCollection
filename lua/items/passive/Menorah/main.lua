local Menorah = {}
local Helpers = RestoredCollection.Helpers
local him = RestoredCollection.HiddenItemManager

---@param player EntityPlayer
---@param cacheFlag CacheFlag | integer
function Menorah:onEvaluateCache(player, cacheFlag)
	local data = RestoredCollection:RunSave(player)

	if cacheFlag == CacheFlag.CACHE_FAMILIARS then
		local numFamiliars = player:GetCollectibleNum(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH)
			+ player:GetEffects():GetCollectibleEffectNum(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH)
		player:CheckFamiliar(
			RestoredCollection.Enums.Familiars.MENORAH.Variant,
			numFamiliars,
			player:GetCollectibleRNG(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH),
			Isaac.GetItemConfig():GetCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH)
		)
	end
	if data.MenorahFlames and data.MenorahFlames > 1 then
		if cacheFlag == CacheFlag.CACHE_DAMAGE and not REPENTOGON then
			if player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH) then
				if data.MenorahFlames == 2 then
					local stack = him:CountStack(player, CollectibleType.COLLECTIBLE_20_20, "MenorahTearModifier")
					local total = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_20_20)
						+ player:GetCollectibleNum(CollectibleType.COLLECTIBLE_20_20)
					if stack == total and (stack + total) > 0 then
						player.Damage = player.Damage / 0.8
					end
				end
			end
		end
		if cacheFlag == CacheFlag.CACHE_FIREDELAY then
			if player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH) then
				local multOffset = 1
				local denoinatorOffset = 0
				if not REPENTOGON then
					local effects = player:GetEffects()
					if
						not player:HasCollectible(CollectibleType.COLLECTIBLE_20_20)
						and not effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_20_20)
						and not player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
						and not effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
					then
						local stack =
							him:CountStack(player, CollectibleType.COLLECTIBLE_INNER_EYE, "MenorahTearModifier")
						local total = player:GetEffects():GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_INNER_EYE)
							+ player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE)
						if stack == total and total > 0 then
							multOffset = 0.52
						end
					end
				end
				if data.MenorahFlames > 1 then
					player.MaxFireDelay = (
						player.MaxFireDelay
						* multOffset
						/ ((data.SewingMachineDenominator or 1) + denoinatorOffset)
					) * data.MenorahFlames
				end
			end
		end
	end
end
RestoredCollection:AddPriorityCallback(ModCallbacks.MC_EVALUATE_CACHE, CallbackPriority.LATE, Menorah.onEvaluateCache)

if REPENTOGON then
	local weaponBlackList = {
		WeaponType.WEAPON_SPIRIT_SWORD,
		WeaponType.WEAPON_MONSTROS_LUNGS,
		WeaponType.WEAPON_LUDOVICO_TECHNIQUE,
		WeaponType.WEAPON_ROCKETS,
	}

	---@param weaponType WeaponType
	---@return boolean
	local function IsBlacklistedWeaponType(weaponType)
		for _, wpType in ipairs(weaponBlackList) do
			if weaponType == wpType then
				return true
			end
		end
		return false
	end

	function Menorah:MultiShotUpdate(player)
		local data = RestoredCollection:RunSave(player)
		local weapon = player:GetWeapon(1)
		local weaponType = weapon:GetWeaponType()
		local multiShotParams = player:GetMultiShotParams(weaponType)
		---@cast multiShotParams MultiShotParams
		if
			data.MenorahFlames
			and data.MenorahFlames > 1
			and player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH)
		then
			multiShotParams:SetNumTears(multiShotParams:GetNumTears() * data.MenorahFlames)
			multiShotParams:SetNumLanesPerEye(multiShotParams:GetNumLanesPerEye() * data.MenorahFlames)
			if not IsBlacklistedWeaponType(weaponType) then
				multiShotParams:SetSpreadAngle(
					weaponType,
					multiShotParams:GetSpreadAngle(weaponType) + 3 * data.MenorahFlames
				)
			end
			if communityRemix then
				Isaac.RunCallback("CR_MC_MULTISHOT_PARAMS", player, multiShotParams, weaponType)
			end
			return multiShotParams
		end
	end
	RestoredCollection:AddPriorityCallback(
		ModCallbacks.MC_POST_PLAYER_GET_MULTI_SHOT_PARAMS,
		CallbackPriority.EARLY,
		Menorah.MultiShotUpdate
	)
else
	local function DupeTear(tear)
		local nt = Isaac.Spawn(tear.Type, tear.Variant, tear.SubType, tear.Position, tear.Velocity, tear):ToTear()
		nt.Parent = tear.Parent
		nt.Color = tear.Color
		nt.FallingSpeed = tear.FallingSpeed
		nt.FallingAcceleration = tear.FallingAcceleration
		nt.Height = tear.Height
		nt.Scale = tear.Scale
		nt.CollisionDamage = tear.CollisionDamage
		nt.TearFlags = nt.TearFlags | tear.TearFlags
		return nt
	end

	local function isEven(number)
		return number % 2 == 0
	end

	function Menorah:postFireTear(tear)
		local player = Helpers.GetPlayerFromTear(tear)
		local tearData = Helpers.GetData(tear)
		if player then
			local data = RestoredCollection:RunSave(player)
			if player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH) then
				tear:Remove()
				for i = 1, data.MenorahFlames do
					local correctedVelocity = tear.Velocity
					if isEven(i) then
						correctedVelocity = tear.Velocity:Rotated(i * -3)
					else
						correctedVelocity = tear.Velocity:Rotated((i - 1) * 3)
					end

					if isEven(data.MenorahFlames) then
						correctedVelocity = correctedVelocity:Rotated(3)
					end

					local spreadTear = DupeTear(tear)
					spreadTear.Velocity = correctedVelocity

					if tearData.FromBowl then
						Helpers.GetData(spreadTear).FromBowl = true
					end
				end
			end
		end
	end

	function Menorah:onLaserUpdate(laser)
		local player = Helpers.GetPlayerFromTear(laser)
		local laserData = Helpers.GetData(laser)

		if player then
			local data = RestoredCollection:RunSave(player)

			if player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH) then
				if (laser.FrameCount == 1) and laser.Parent then
					if not laserData.isSpreadLaser and (laser.Parent:ToPlayer() or laserData.IsFamiliarPlayerTear) then
						if (laser.SubType == LaserSubType.LASER_SUBTYPE_LINEAR) and laser.Timeout ~= -1 then
							for i = 2, data.MenorahFlames do
								local correctedVelocity = laser.StartAngleDegrees - ((i - 1) * 3)
								if i % 2 == 0 then
									correctedVelocity = laser.StartAngleDegrees + (i * 3)
								end

								local spreadLaser = nil
								if not laserData.IsFamiliarPlayerTear then
									spreadLaser = EntityLaser.ShootAngle(
										laser.Variant,
										laser.Position,
										correctedVelocity,
										laser.Timeout,
										laser.PositionOffset,
										player
									)
								elseif laserData.IsFamiliarPlayerTear then
									spreadLaser = EntityLaser.ShootAngle(
										laser.Variant,
										laser.Position,
										correctedVelocity,
										laser.Timeout,
										laser.PositionOffset,
										laser.Parent:ToFamiliar()
									)
								end
								Helpers.GetData(spreadLaser).isSpreadLaser = true

								spreadLaser.TearFlags = laser.TearFlags
								spreadLaser:SetBlackHpDropChance(laser.BlackHpDropChance)
								spreadLaser:SetMaxDistance(laser.MaxDistance)
								spreadLaser:SetOneHit(laser.OneHit)
								spreadLaser:SetActiveRotation(
									laser.RotationDelay,
									laser.RotationDegrees,
									laser.RotationSpd,
									true
								)
								spreadLaser:SetTimeout(laser.Timeout)

								spreadLaser.CurveStrength = laser.CurveStrength
								spreadLaser.DisableFollowParent = laser.DisableFollowParent
								spreadLaser.IsActiveRotating = laser.IsActiveRotating
								spreadLaser.ParentOffset = laser.ParentOffset

								spreadLaser.CollisionDamage = laser.CollisionDamage
								spreadLaser.DepthOffset = laser.DepthOffset
								spreadLaser.EntityCollisionClass = laser.EntityCollisionClass
								spreadLaser.FlipX = laser.FlipX
								spreadLaser.Friction = laser.Friction
								spreadLaser.GridCollisionClass = laser.GridCollisionClass
								spreadLaser.HitPoints = laser.HitPoints
								spreadLaser.Mass = laser.Mass
								spreadLaser.MaxHitPoints = laser.MaxHitPoints
								spreadLaser.RenderZOffset = laser.RenderZOffset
								spreadLaser.SplatColor = laser.SplatColor
								spreadLaser.SpriteOffset = laser.SpriteOffset
								spreadLaser.SpriteRotation = laser.SpriteRotation
								spreadLaser.SpriteScale = laser.SpriteScale
								spreadLaser.Target = laser.Target
								spreadLaser.TargetPosition = laser.TargetPosition
								spreadLaser.Visible = laser.Visible
								spreadLaser.Size = laser.Size
								spreadLaser.SizeMulti = laser.SizeMulti

								local spreadSprite = spreadLaser:GetSprite()
								local sprite = laser:GetSprite()
								spreadSprite.Color = sprite.Color
								spreadSprite.FlipX = sprite.FlipX
								spreadSprite.FlipY = sprite.FlipY
								spreadSprite.Offset = sprite.Offset
								spreadSprite.PlaybackSpeed = sprite.PlaybackSpeed
								spreadSprite.Rotation = sprite.Rotation
								spreadSprite.Scale = sprite.Scale
							end
						elseif laser.SubType == LaserSubType.LASER_SUBTYPE_RING_PROJECTILE then
							for i = 1, data.MenorahFlames do
								local correctedVelocity = laser.Velocity:Rotated((i - 1) * -3)
								if i % 2 == 0 then
									correctedVelocity = laser.Velocity:Rotated(i * 3)
								end

								local spreadLaser = nil
								if not laserData.IsFamiliarPlayerTear then
									spreadLaser =
										player:FireTechXLaser(player.Position, correctedVelocity, laser.Radius, player)
								elseif laserData.IsFamiliarPlayerTear then
									spreadLaser = player:FireTechXLaser(
										player.Position,
										correctedVelocity,
										laser.Radius,
										laser.Parent:ToFamiliar()
									)
								end
								Helpers.GetData(spreadLaser).isSpreadLaser = true

								spreadLaser.TearFlags = laser.TearFlags
								spreadLaser:SetBlackHpDropChance(laser.BlackHpDropChance)
								spreadLaser:SetMaxDistance(laser.MaxDistance)
								spreadLaser:SetOneHit(laser.OneHit)
								spreadLaser:SetTimeout(laser.Timeout)

								spreadLaser.CurveStrength = laser.CurveStrength
								spreadLaser.DisableFollowParent = laser.DisableFollowParent
								spreadLaser.IsActiveRotating = laser.IsActiveRotating
								spreadLaser.ParentOffset = laser.ParentOffset

								local spreadSprite = spreadLaser:GetSprite()
								local sprite = laser:GetSprite()
								spreadSprite.Color = sprite.Color
								spreadSprite.FlipX = sprite.FlipX
								spreadSprite.FlipY = sprite.FlipY
								spreadSprite.Offset = sprite.Offset
								spreadSprite.PlaybackSpeed = sprite.PlaybackSpeed
								spreadSprite.Rotation = sprite.Rotation
								spreadSprite.Scale = sprite.Scale

								laser:Remove()
							end
						end
					end
				end
			end
		end
	end

	function Menorah:onBombUpdate(bomb)
		local player = Helpers.GetPlayerFromTear(bomb)
		local bombData = Helpers.GetData(bomb)

		if player then
			local data = RestoredCollection:RunSave(player)
			if player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH) then
				if (bomb.FrameCount == 1) and bomb.Parent and (bomb.IsFetus == true) then
					if (not bombData.isSpreadBomb) and (bomb.Parent:ToPlayer() or bombData.IsFamiliarPlayerTear) then
						for i = 1, data.MenorahFlames do
							local correctedVelocity = bomb.Velocity:Rotated((i - 1) * -3)
							if i % 2 == 0 then
								correctedVelocity = bomb.Velocity:Rotated(i * 3)
							end

							local spreadBomb = nil
							if not bombData.IsFamiliarPlayerTear then
								--spreadBomb = player:FireBomb(bomb.Position, correctedVelocity, player)
								spreadBomb = Isaac.Spawn(
									bomb.Type,
									bomb.Variant,
									bomb.SubType,
									bomb.Position,
									correctedVelocity,
									player
								):ToBomb()
							elseif bombData.IsFamiliarPlayerTear then
								--spreadBomb = player:FireBomb(bomb.Position, correctedVelocity, bomb.Parent:ToFamiliar())
								spreadBomb = Isaac.Spawn(
									bomb.Type,
									bomb.Variant,
									bomb.SubType,
									bomb.Position,
									correctedVelocity,
									bomb.Parent:ToFamiliar()
								):ToBomb()
							end
							Helpers.GetData(spreadBomb).isSpreadBomb = true

							spreadBomb.ExplosionDamage = bomb.ExplosionDamage
							spreadBomb.Flags = bomb.Flags
							spreadBomb.IsFetus = bomb.IsFetus
							spreadBomb.RadiusMultiplier = bomb.RadiusMultiplier

							local spreadSprite = spreadBomb:GetSprite()
							local sprite = bomb:GetSprite()
							spreadSprite.Color = sprite.Color
							spreadSprite.FlipX = sprite.FlipX
							spreadSprite.FlipY = sprite.FlipY
							spreadSprite.Offset = sprite.Offset
							spreadSprite.PlaybackSpeed = sprite.PlaybackSpeed
							spreadSprite.Rotation = sprite.Rotation
							spreadSprite.Scale = sprite.Scale

							bomb:Remove()
						end
					end
				end
			end
		end
	end
	--[[RestoredCollection:AddCallback(ModCallbacks.MC_POST_FIRE_TEAR, Menorah.postFireTear)
	RestoredCollection:AddCallback(ModCallbacks.MC_POST_LASER_UPDATE, Menorah.onLaserUpdate)
	RestoredCollection:AddCallback(ModCallbacks.MC_POST_BOMB_UPDATE, Menorah.onBombUpdate)
	]]

	---@param player EntityPlayer
	function Menorah:MultiShotUpdate(player)
		local data = RestoredCollection:RunSave(player)
		if not player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH) then
			data.MenorahFlames = 1
		end
		local effects = player:GetEffects()
		local flames2020 = 0
		local flamesInner = 0
		if data.MenorahFlames and data.MenorahFlames > 1 then
			if data.MenorahFlames == 2 then
				flames2020 = 1
				if
					player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
					or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
					or Helpers.IsAnyPlayerType(player, PlayerType.PLAYER_KEEPER, PlayerType.PLAYER_KEEPER_B)
				then
					flames2020 = 0
					flamesInner = 1
				elseif
					player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
					or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE)
				then
					if
						him:CountStack(player, CollectibleType.COLLECTIBLE_INNER_EYE, "MenorahTearModifier")
						< player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE)
							+ effects:GetCollectibleEffectNum(CollectibleType.COLLECTIBLE_INNER_EYE)
					then
						flames2020 = 0
						flamesInner = 1
					end
				end
			else
				local offset = 2
				if
					player:HasCollectible(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
					or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_MUTANT_SPIDER)
					or (
						(
							player:HasCollectible(CollectibleType.COLLECTIBLE_INNER_EYE)
							or effects:HasCollectibleEffect(CollectibleType.COLLECTIBLE_INNER_EYE)
						)
							and him:CountStack(player, CollectibleType.COLLECTIBLE_INNER_EYE, "MenorahTearModifier")
								< player:GetCollectibleNum(CollectibleType.COLLECTIBLE_INNER_EYE) + effects:GetCollectibleEffectNum(
									CollectibleType.COLLECTIBLE_INNER_EYE
								)
					)
					or Helpers.IsAnyPlayerType(player, PlayerType.PLAYER_KEEPER, PlayerType.PLAYER_KEEPER_B)
				then
					offset = 1
				end
				flamesInner = data.MenorahFlames - offset
			end
		end
		if flames2020 ~= him:CountStack(player, CollectibleType.COLLECTIBLE_20_20, "MenorahTearModifier") then
			him:CheckStack(player, CollectibleType.COLLECTIBLE_20_20, flames2020, "MenorahTearModifier")
			player:AddCacheFlags(CacheFlag.CACHE_DAMAGE)
			player:EvaluateItems()
		end
		if flamesInner ~= him:CountStack(player, CollectibleType.COLLECTIBLE_INNER_EYE, "MenorahTearModifier") then
			him:CheckStack(player, CollectibleType.COLLECTIBLE_INNER_EYE, flamesInner, "MenorahTearModifier")
			player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
			player:EvaluateItems()
		end
		him:HideCostumes("MenorahTearModifier")
	end
	RestoredCollection:AddCallback(ModCallbacks.MC_POST_PEFFECT_UPDATE, Menorah.MultiShotUpdate)
end

function Menorah:onFamiliarInit(menorah)
	local player = menorah.Player
	local data = RestoredCollection:RunSave(player)
	if not data.MenorahFlames then
		data.MenorahFlames = 1
	end

	menorah:AddToFollowers()
end
RestoredCollection:AddCallback(
	ModCallbacks.MC_FAMILIAR_INIT,
	Menorah.onFamiliarInit,
	RestoredCollection.Enums.Familiars.MENORAH.Variant
)

function Menorah:onFamiliarUpdate(menorah)
	local sprite = menorah:GetSprite()
	local player = menorah.Player
	local data = RestoredCollection:RunSave(player)
	if not data.MenorahFlames then
		data.MenorahFlames = 1
	end
	if data.MenorahFlames == 1 then
		sprite:Play("Idle1", false)
	elseif data.MenorahFlames == 2 then
		sprite:Play("Idle2", false)
	elseif data.MenorahFlames == 3 then
		sprite:Play("Idle3", false)
	elseif data.MenorahFlames == 4 then
		sprite:Play("Idle4", false)
	elseif data.MenorahFlames == 5 then
		sprite:Play("Idle5", false)
	elseif data.MenorahFlames == 6 then
		sprite:Play("Idle6", false)
	elseif data.MenorahFlames == 7 then
		sprite:Play("Idle7", false)
	elseif data.MenorahFlames == 0 then
		sprite:Play("Burst", false)
		if sprite:IsEventTriggered("Burst") then
			data.MenorahTimer = menorah.FrameCount
			if not data.SewingMachineUltra then
				player:SetShootingCooldown(240)
			end
			local shotSpeed = player.ShotSpeed * 10

			for i = 1, 8 do
				local projVel = Vector(0, 1) * shotSpeed
				if i == 2 then
					projVel = Vector(0, -1) * shotSpeed
				elseif i == 3 then
					projVel = Vector(1, 0) * shotSpeed
				elseif i == 4 then
					projVel = Vector(-1, 0) * shotSpeed
				elseif i == 5 then
					projVel = Vector(1, 1) * shotSpeed
				elseif i == 6 then
					projVel = Vector(1, -1) * shotSpeed
				elseif i == 7 then
					projVel = Vector(-1, 1) * shotSpeed
				elseif i == 8 then
					projVel = Vector(-1, -1) * shotSpeed
				end
				local flame = Isaac.Spawn(
					EntityType.ENTITY_EFFECT,
					EffectVariant.BLUE_FLAME,
					0,
					menorah.Position,
					projVel,
					menorah
				):ToEffect()
				flame:SetDamageSource(EntityType.ENTITY_PLAYER)
				flame.LifeSpan = 60
				flame.Timeout = 60
				flame.State = 1
				flame.CollisionDamage = 23
			end
		end
	end

	if data.MenorahFlames == 0 then
		if data.MenorahTimer then
			if menorah.FrameCount == data.MenorahTimer + 120 then
				data.MenorahFlames = 1
			end
		end
	end
	menorah:FollowParent()
end
RestoredCollection:AddCallback(
	ModCallbacks.MC_FAMILIAR_UPDATE,
	Menorah.onFamiliarUpdate,
	RestoredCollection.Enums.Familiars.MENORAH.Variant
)

function Menorah:onDamage(tookDamage, damageAmount, damageFlags, damageSource, damageCountdownFrames)
	local player = tookDamage:ToPlayer()
	local data = RestoredCollection:RunSave(player)

	if player:HasCollectible(RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH) then
		if data.MenorahFlames > 0 then
			data.MenorahFlames = data.MenorahFlames + 1

			if data.MenorahFlames > 7 then
				data.MenorahFlames = 0
			end

			player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY)
			player:EvaluateItems()
		end
	end
end
RestoredCollection:AddCallback(ModCallbacks.MC_ENTITY_TAKE_DMG, Menorah.onDamage, EntityType.ENTITY_PLAYER)

if Sewn_API then
	Sewn_API:MakeFamiliarAvailable(
		RestoredCollection.Enums.Familiars.MENORAH.Variant,
		RestoredCollection.Enums.CollectibleType.COLLECTIBLE_MENORAH
	)

	local function MenorahSewingUpdateDefault(_, menorah)
		local data = RestoredCollection:RunSave(menorah.Player)
		data.SewingMachineDenominator = 2
	end
	local function MenorahSewingUpdateUltra(_, menorah)
		local data = RestoredCollection:RunSave(menorah.Player)
		data.SewingMachineDenominator = 3
		data.SewingMachineUltra = true
	end

	Sewn_API:AddCallback(
		Sewn_API.Enums.ModCallbacks.FAMILIAR_UPDATE,
		MenorahSewingUpdateDefault,
		RestoredCollection.Enums.Familiars.MENORAH.Variant
	)
	Sewn_API:AddCallback(
		Sewn_API.Enums.ModCallbacks.FAMILIAR_UPDATE,
		MenorahSewingUpdateUltra,
		RestoredCollection.Enums.Familiars.MENORAH.Variant,
		Sewn_API.Enums.FamiliarLevelFlag.FLAG_ULTRA
	)
end
