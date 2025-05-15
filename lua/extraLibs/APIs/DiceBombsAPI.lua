local localversion = 1.0
local name = "Dice Bombs API"

local function Log(str)
	print(str)
	Isaac.DebugString(str)
end

local function load(data)
	DiceBombsAPI = RegisterMod(name, 1)
	DiceBombsAPI.Version = localversion
	DiceBombsAPI.Loaded = false

	local DiceBombSpritesheets = {
		[CollectibleType.COLLECTIBLE_D1] = {
			"gfx/items/pick ups/bombs/costumes/dice_d1.png",
			"gfx/items/pick ups/bombs/costumes/dice_d1_gold.png",
		},
		[CollectibleType.COLLECTIBLE_D4] = {
			"gfx/items/pick ups/bombs/costumes/dice_d4.png",
			"gfx/items/pick ups/bombs/costumes/dice_d4_gold.png",
		},
		[CollectibleType.COLLECTIBLE_D6] = {
			"gfx/items/pick ups/bombs/costumes/dice_d6.png",
			"gfx/items/pick ups/bombs/costumes/dice_d6_gold.png",
		},
		[CollectibleType.COLLECTIBLE_D8] = {
			"gfx/items/pick ups/bombs/costumes/dice_d8.png",
			"gfx/items/pick ups/bombs/costumes/dice_d8_gold.png",
		},
		[CollectibleType.COLLECTIBLE_D20] = {
			"gfx/items/pick ups/bombs/costumes/dice_d20.png",
			"gfx/items/pick ups/bombs/costumes/dice_d20_gold.png",
		},
		[CollectibleType.COLLECTIBLE_D100] = {
			"gfx/items/pick ups/bombs/costumes/dice_d100.png",
			"gfx/items/pick ups/bombs/costumes/dice_d100_gold.png",
		},
		[CollectibleType.COLLECTIBLE_SPINDOWN_DICE] = {
			"gfx/items/pick ups/bombs/costumes/dice_spindown.png",
			"gfx/items/pick ups/bombs/costumes/dice_spindown_gold.png",
		},
	}

	if data then
		DiceBombSpritesheets = data
	end

	function DiceBombsAPI.AddDice(diceID, gfxNormal, gfxGolden)
		if diceID and type(diceID) == "number" and not DiceBombSpritesheets[diceID] then
			local normalBombGFX = "gfx/items/pick ups/bombs/costumes/dice_modded.png"
			local goldenBombGFX = "gfx/items/pick ups/bombs/costumes/dice_modded_gold.png"
			if gfxNormal and type(gfxNormal) == "string" then
				normalBombGFX = gfxNormal
			end
			if gfxGolden and type(gfxGolden) == "string" then
				goldenBombGFX = gfxGolden
			end
			DiceBombSpritesheets[diceID] = { normalBombGFX, goldenBombGFX }
		end
	end

	function DiceBombsAPI.GetDiceBombsSprites(dice)
		if dice then
			return DiceBombSpritesheets[dice]
		end
		return DiceBombSpritesheets
	end

	function DiceBombsAPI:ModReset()
		DiceBombsAPI.Loaded = false
	end
	DiceBombsAPI:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, DiceBombsAPI.ModReset)

	function DiceBombsAPI:ModLoad()
		if not DiceBombsAPI.Loaded then
			Log("[" .. DiceBombsAPI.Name .. "] is loaded. Version " .. DiceBombsAPI.Version)
			DiceBombsAPI.Loaded = true
		end
	end
	DiceBombsAPI:AddCallback(
		REPENTOGON and ModCallbacks.MC_POST_MODS_LOADED or ModCallbacks.MC_POST_GAME_STARTED,
		DiceBombsAPI.ModLoad
	)
end

if DiceBombsAPI then
	if DiceBombsAPI.Version < localversion or not DiceBombsAPI.Loaded then
		if not DiceBombsAPI.Loaded then
			Log("[" .. DiceBombsAPI.Name .. "] Reloading...")
		else
			Log(
				"["
					.. DiceBombsAPI.Name
					.. "] Found old script V"
					.. DiceBombsAPI.Version
					.. ". Replacing with V"
					.. localversion
			)
		end
		local data = DiceBombsAPI.GetDiceBombsSprites()
		DiceBombsAPI = nil
		load(data)
		DiceBombsAPI:ModLoad()
	end
elseif not DiceBombsAPI then
	load()
	DiceBombsAPI:ModLoad()
end
