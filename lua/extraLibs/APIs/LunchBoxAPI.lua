local localversion = 1.0
local name = "Lunchbox API"

local function Log(str)
	print(str)
	Isaac.DebugString(str)
end

local function load(data)
	LunchBox = RegisterMod(name, 1)
	LunchBox.Version = localversion
	LunchBox.Loaded = false

	local LunchBoxPickupData = {}
	if data then
		LunchBoxPickupData = data
	end

	function LunchBox.AddPickup(variant, subtype, charge, func)
		if
			type(variant) ~= "number"
			or type(subtype) ~= "number"
			or type(charge) ~= "number"
			or type(func) ~= "function"
		then
			Log(
				"Couldn't add pickup to charge Lunchbox. Variant: "
					.. tostring(variant)
					.. ", SubType: "
					.. tostring(subtype)
					.. ", Charge: "
					.. tostring(charge)
					.. "."
			)
			Log("Function type is " .. type(func))
			return
		end
		if not LunchBoxPickupData[variant] then
			LunchBoxPickupData[variant] = {}
		end
		if LunchBoxPickupData[variant][subtype] then
			if LunchBox.Loaded then
				Log(
					"This Variant: " .. tostring(variant) .. " and SubType: " .. tostring(subtype) .. " already exists."
				)
			end
			return
		end
		LunchBoxPickupData[variant][subtype] = { Charge = charge, Function = func }
	end

	function LunchBox.GetPickupData(variant, subtype)
		if variant then
			if subtype then
				return LunchBoxPickupData[variant][subtype]
			end
			return LunchBoxPickupData[variant]
		end
		return LunchBoxPickupData
	end

	function LunchBox:ModReset()
		LunchBox.Loaded = false
	end
	LunchBox:AddCallback(ModCallbacks.MC_PRE_MOD_UNLOAD, LunchBox.ModReset)

	function LunchBox:ModLoad()
		if not LunchBox.Loaded then
			LunchBox.Loaded = true
			Log("[" .. LunchBox.Name .. "] is loaded. Version " .. LunchBox.Version)
		end
	end
	LunchBox:AddCallback(
		REPENTOGON and ModCallbacks.MC_POST_MODS_LOADED or ModCallbacks.MC_POST_GAME_STARTED,
		LunchBox.ModLoad
	)
end

if LunchBox then
	if LunchBox.Version < localversion or not LunchBox.Loaded then
		if not LunchBox.Loaded then
			Log("[" .. LunchBox.Name .. "] Reloading...")
		else
			Log(
			"["
					.. LunchBox.Name
					.. "] Found old script V"
					.. LunchBox.Version
					.. ". Replacing with V"
					.. localversion
			)
		end
		local data = LunchBox.GetPickupData()
		LunchBox = nil
		load(data)
		LunchBox:ModLoad()
	end
elseif not LunchBox then
	load()
	LunchBox:ModLoad()
end
