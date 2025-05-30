local DSSModName = "Restored Collection"

local DSSCoreVersion = 7

local modMenuName = "Restored Collection"
-- Those functions were taken from Balance Mod, just to make things easier
local BREAK_LINE = { str = "", fsize = 1, nosel = true }

local function GenerateTooltip(str)
	local endTable = {}
	local currentString = ""
	for w in str:gmatch("%S+") do
		local newString = currentString .. w .. " "
		if newString:len() >= 15 then
			table.insert(endTable, currentString)
			currentString = ""
		end

		currentString = currentString .. w .. " "
	end

	table.insert(endTable, currentString)
	return { strset = endTable }
end
-- Thanks to catinsurance for those functions


-- Every MenuProvider function below must have its own implementation in your mod, in order to handle menu save data.
local MenuProvider = {}

function MenuProvider.SaveSaveData()
	RestoredCollection.SaveManager.Save()
end

function MenuProvider.GetPaletteSetting()
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuPalette or nil
end

function MenuProvider.SavePaletteSetting(var)
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenuPalette = var
end

function MenuProvider.GetGamepadToggleSetting()
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.GamepadToggle or nil
end

function MenuProvider.SaveGamepadToggleSetting(var)
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    dssSave.GamepadToggle = var
end

function MenuProvider.GetMenuKeybindSetting()
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuKeybind or nil
end

function MenuProvider.SaveMenuKeybindSetting(var)
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenuKeybind = var
end

function MenuProvider.GetMenuHintSetting()
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuHint or nil
end

function MenuProvider.SaveMenuHintSetting(var)
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenuHint = var
end

function MenuProvider.GetMenuBuzzerSetting()
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenuBuzzer or nil
end

function MenuProvider.SaveMenuBuzzerSetting(var)
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenuBuzzer = var
end

function MenuProvider.GetMenusNotified()
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenusNotified or nil
end

function MenuProvider.SaveMenusNotified(var)
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    dssSave.MenusNotified = var
end

function MenuProvider.GetMenusPoppedUp()
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
    return dssSave and dssSave.MenusPoppedUp or nil
end

function MenuProvider.SaveMenusPoppedUp(var)
    local dssSave = RestoredCollection.SaveManager.GetDeadSeaScrollsSave()
   dssSave.MenusPoppedUp = var
end

local DSSInitializerFunction = include("lua.core.dss.dssmenucore")

-- This function returns a table that some useful functions and defaults are stored on
local dssmod = DSSInitializerFunction(DSSModName, DSSCoreVersion, MenuProvider)

local function RemoveZeroWidthSpace(str)
	if str:sub(1, 3) == "​" then
		str = str:sub(4, str:len())
	end
	return str
end

local function SplitStr(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, RemoveZeroWidthSpace(str))
	end
	return t
end

local function GetItemsEnum(id)
	for enum, collectible in pairs(RestoredCollection.Enums.CollectibleType) do
		if id == collectible then
			return enum
		end
	end
	return ""
end

local orderedItems = {}

local function InitBlacklistItems()
	orderedItems = {}
	local itemConfig = Isaac.GetItemConfig()
	---@type ItemConfigItem[]
	for _, collectible in pairs(RestoredCollection.Enums.CollectibleType) do
		local collectibleConf = itemConfig:GetCollectible(collectible)
		orderedItems[#orderedItems + 1] = collectibleConf
	end
	table.sort(orderedItems, function(a, b)
		return RemoveZeroWidthSpace(a.Name) < RemoveZeroWidthSpace(b.Name)
	end)
end

InitBlacklistItems()

local function InitDisableMenu()
	local itemTogglesMenu = {}
	itemTogglesMenu = {
		{str = 'choose what items show up', fsize = 2, nosel = true},
        {str = '(disabled - in blacklist)', fsize = 2, nosel = true},
		{ str = "", fsize = 2, nosel = true },
	}

	for _, collectible in pairs(orderedItems) do
		local split = SplitStr(string.lower(collectible.Name))

		local tooltipStr = { "enable", "" }
		for _, word in ipairs(split) do
			if tooltipStr[#tooltipStr]:len() + word:len() > 15 then
				tooltipStr[#tooltipStr] = tooltipStr[#tooltipStr]:sub(0, tooltipStr[#tooltipStr]:len() - 1)
				tooltipStr[#tooltipStr + 1] = word .. " "
			else
				tooltipStr[#tooltipStr] = tooltipStr[#tooltipStr] .. word .. " "
			end
		end
		tooltipStr[#tooltipStr] = tooltipStr[#tooltipStr]:sub(0, tooltipStr[#tooltipStr]:len() - 1)

		local itemSprite = Sprite()
		itemSprite:Load("gfx/ui/dss_item.anm2", false)
		itemSprite:ReplaceSpritesheet(0, collectible.GfxFileName)
		itemSprite:LoadGraphics()
		itemSprite:SetFrame("Idle", 0)

		local collectibleOption = {
			str = string.lower(RemoveZeroWidthSpace(collectible.Name)),

			-- The "choices" tag on a button allows you to create a multiple-choice setting
			choices = { "enabled", "disabled" },
			-- The "setting" tag determines the default setting, by list index. EG "1" here will result in the default setting being "choice a"
			setting = 1,

			-- "variable" is used as a key to story your setting; just set it to something unique for each setting!
			variable = "ToggleItem" .. collectible.Name,

			-- When the menu is opened, "load" will be called on all settings-buttons
			-- The "load" function for a button should return what its current setting should be
			-- This generally means looking at your mod's save data, and returning whatever setting you have stored
			load = function()
				for _, disabledItem in
					ipairs(RestoredCollection:GetDefaultFileSave("DisabledItems"))
				do
					if disabledItem == GetItemsEnum(collectible.ID) then
						return 2
					end
				end
				return 1
			end,

			-- When the menu is closed, "store" will be called on all settings-buttons
			-- The "store" function for a button should save the button's setting (passed in as the first argument) to save data!
			store = function(var)
				local disabledItems = RestoredCollection:GetDefaultFileSave("DisabledItems")
				for index, disabledItem in ipairs(disabledItems) do
					if disabledItem == GetItemsEnum(collectible.ID) then
						if var == 1 then
							table.remove(disabledItems, index)
						end
						break
					end
				end

				if var == 2 then
					table.insert(disabledItems, GetItemsEnum(collectible.ID))
				end
			end,

			-- A simple way to define tooltips is using the "strset" tag, where each string in the table is another line of the tooltip
			tooltip = {
				buttons = {
					{
						spr = {
							sprite = itemSprite,
							centerx = 16,
							centery = 16,
							width = 32,
							height = 32,
							float = { 1, 6 },
							shadow = true,
							nosel = true,
						},
					},
					{ strset = tooltipStr },
				},
			},
		}

		itemTogglesMenu[#itemTogglesMenu + 1] = collectibleOption
	end
	return itemTogglesMenu
end

local function UpdateImGuiMenu(IsDataInitialized)
	if IsDataInitialized then

		if ImGui.ElementExists("restotredCollectionSettingsNoWay") then
			ImGui.RemoveElement("restotredCollectionSettingsNoWay")
		end

		if ImGui.ElementExists("restotredCollectionBlacklistNoWay") then
			ImGui.RemoveElement("restotredCollectionBlacklistNoWay")
		end

		if ImGui.ElementExists("restoredCollectionSettingsIllusionPlaceBombs") then
			ImGui.RemoveElement("restoredCollectionSettingsIllusionPlaceBombs")
		end

		ImGui.AddCheckbox(
			"restoredCollectionSettingsWindow",
			"restoredCollectionSettingsIllusionPlaceBombs",
			"Illusions can place bombs",
			function(val)
				IllusionMod.CanPlaceBomb = val
			end,
			false
		)
		ImGui.SetTooltip("restoredCollectionSettingsIllusionPlaceBombs", "Illusion place bombs same bombs as player")

		if ImGui.ElementExists("restoredCollectionSettingsIllusionPerfect") then
			ImGui.RemoveElement("restoredCollectionSettingsIllusionPerfect")
		end

		ImGui.AddCheckbox(
			"restoredCollectionSettingsWindow",
			"restoredCollectionSettingsIllusionPerfect",
			"Perfect illusion",
			function(val)
				IllusionMod.PerfectIllusion = val
			end,
			false
		)
		ImGui.SetTooltip("restoredCollectionSettingsIllusionPerfect", "Makes exact copy of player character")

		if ImGui.ElementExists("restoredCollectionSettingsMaxsHeads") then
			ImGui.RemoveElement("restoredCollectionSettingsMaxsHeads")
		end

		ImGui.AddCheckbox(
			"restoredCollectionSettingsWindow",
			"restoredCollectionSettingsMaxsHeads",
			"Max's Head Emoji",
			function(val)
				local newOption = val and 2 or 1
				RestoredCollection:AddDefaultFileSave("MaxsHead", newOption)
			end,
			false
		)
		ImGui.SetTooltip("restoredCollectionSettingsMaxsHeads", "Allow Max's head emojis appear when shooting tears.")

		ImGui.AddCallback("restoredCollectionSettingsWindow", ImGuiCallback.Render, function()
			ImGui.UpdateData(
				"restoredCollectionSettingsIllusionPlaceBombs",
				ImGuiData.Value,
				IllusionMod.CanPlaceBomb
			)
			ImGui.UpdateData(
				"restoredCollectionSettingsIllusionPerfect",
				ImGuiData.Value,
				IllusionMod.PerfectIllusion
			)
			ImGui.UpdateData(
				"restoredCollectionSettingsMaxsHeads",
				ImGuiData.Value,
				RestoredCollection:GetDefaultFileSave("MaxsHead") > 1
			)
		end)

		for _, collectible in pairs(orderedItems) do
			local tooltipStr = "Enable " .. RemoveZeroWidthSpace(collectible.Name) .. "\nin item pools"

			local elemName = "restoredCollection" .. string.gsub(collectible.Name, " ", "") .. "Blacklist"
			if ImGui.ElementExists(elemName) then
				ImGui.RemoveElement(elemName)
			end

			ImGui.AddCheckbox(
				"restoredCollectionItemsBlacklistWindow",
				elemName,
				RemoveZeroWidthSpace(collectible.Name),
				function(val)
					local disabledItems = RestoredCollection:GetDefaultFileSave("DisabledItems")
					for indexItem, disabledItem in ipairs(disabledItems) do
						if disabledItem == GetItemsEnum(collectible.ID) then
							if val then
								table.remove(disabledItems, indexItem)
							end
							break
						end
					end

					if not val then
						table.insert(disabledItems, GetItemsEnum(collectible.ID))
					end
				end,
				true
			)

			ImGui.SetTooltip(elemName, tooltipStr)
			ImGui.AddCallback(elemName, ImGuiCallback.Render, function()
				local val = true
				for indexItem, disabledItem in
					ipairs(RestoredCollection:GetDefaultFileSave("DisabledItems"))
				do
					if disabledItem == GetItemsEnum(collectible.ID) then
						val = false
						break
					end
				end
				ImGui.UpdateData(elemName, ImGuiData.Value, val)
			end)
		end
	else

		ImGui.RemoveCallback("restoredCollectionMenu", ImGuiCallback.Render)

		for _, collectible in pairs(orderedItems) do
			local elemName = "restoredCollection" .. string.gsub(collectible.Name, " ", "") .. "Blacklist"
			if ImGui.ElementExists(elemName) then
				ImGui.RemoveCallback(elemName, ImGuiCallback.Render)
				ImGui.RemoveElement(elemName)
			end
		end

		if ImGui.ElementExists("restoredCollectionSettingsIllusionPlaceBombs") then
			ImGui.RemoveElement("restoredCollectionSettingsIllusionPlaceBombs")
		end

		if ImGui.ElementExists("restoredCollectionSettingsIllusionPerfect") then
			ImGui.RemoveElement("restoredCollectionSettingsIllusionPerfect")
		end

		if ImGui.ElementExists("restoredCollectionSettingsMaxsHeads") then
			ImGui.RemoveElement("restoredCollectionSettingsMaxsHeads")
		end

		if not ImGui.ElementExists("restotredCollectionSettingsNoWay") then
			ImGui.AddText("restoredCollectionSettingsWindow", "Options will be available after loading the game.", true, "restotredCollectionSettingsNoWay")
		end

		if not ImGui.ElementExists("restotredCollectionBlacklistNoWay") then
			ImGui.AddText("restoredCollectionItemsBlacklistWindow", "Options will be available after loading the game.", true, "restotredCollectionBlacklistNoWay")
		end
	end
end

local function InitImGuiMenu()
	if not ImGui.ElementExists("RestoredMods") then
		ImGui.CreateMenu("RestoredMods", "Restored Mods")
	end

	if not ImGui.ElementExists("restoredCollectionMenu") then
		ImGui.AddElement("RestoredMods", "restoredCollectionMenu", ImGuiElement.Menu, "Restored Collection")
	end

	if not ImGui.ElementExists("restoredCollectionSettings") then
		ImGui.AddElement(
			"restoredCollectionMenu",
			"restoredCollectionSettings",
			ImGuiElement.MenuItem,
			"\u{f013} Settings"
		)
	end

	if not ImGui.ElementExists("restoredCollectionSettingsWindow") then
		ImGui.CreateWindow("restoredCollectionSettingsWindow", "Restored Collection settings")

		ImGui.LinkWindowToElement("restoredCollectionSettingsWindow", "restoredCollectionSettings")

		ImGui.SetWindowSize("restoredCollectionSettingsWindow", 600, 420)
	end

	if not ImGui.ElementExists("restoredCollectionItemsBlacklistSettings") then
		ImGui.AddElement(
			"restoredCollectionMenu",
			"restoredCollectionItemsBlacklistSettings",
			ImGuiElement.MenuItem,
			"\u{f05e} Items blacklist"
		)
	end

	if not ImGui.ElementExists("restoredCollectionItemsBlacklistWindow") then
		ImGui.CreateWindow("restoredCollectionItemsBlacklistWindow", "Restored Collection items blacklist")
		ImGui.LinkWindowToElement("restoredCollectionItemsBlacklistWindow", "restoredCollectionItemsBlacklistSettings")

		ImGui.SetWindowSize("restoredCollectionItemsBlacklistWindow", 350, 600)
	end


end

-- Creating a menu like any other DSS menu is a simple process.
-- You need a "Directory", which defines all of the pages ("items") that can be accessed on your menu, and a "DirectoryKey", which defines the state of the menu.
local restoreditemsdirectory = {
	-- The keys in this table are used to determine button destinations.
	main = {
		-- "title" is the big line of text that shows up at the top of the page!
		title = "restored collection",

		-- "buttons" is a list of objects that will be displayed on this page. The meat of the menu!
		buttons = {
			-- The simplest button has just a "str" tag, which just displays a line of text.

			-- The "action" tag can do one of three pre-defined actions:
			--- "resume" closes the menu, like the resume game button on the pause menu. Generally a good idea to have a button for this on your main page!
			--- "back" backs out to the previous menu item, as if you had sent the menu back input
			--- "openmenu" opens a different dss menu, using the "menu" tag of the button as the name
			{ str = "resume game", action = "resume" },

			-- The "dest" option, if specified, means that pressing the button will send you to that page of your menu.
			-- If using the "openmenu" action, "dest" will pick which item of that menu you are sent to.
			{ str = "settings", dest = "settings" },

			{ str = "items blacklist", dest = "items" },
			-- A few default buttons are provided in the table returned from DSSInitializerFunction.
			-- They're buttons that handle generic menu features, like changelogs, palette, and the menu opening keybind
			-- They'll only be visible in your menu if your menu is the only mod menu active; otherwise, they'll show up in the outermost Dead Sea Scrolls menu that lets you pick which mod menu to open.
			-- This one leads to the changelogs menu, which contains changelogs defined by all mods.
			dssmod.changelogsButton,
		},

		-- A tooltip can be set either on an item or a button, and will display in the corner of the menu while a button is selected or the item is visible with no tooltip selected from a button.
		-- The object returned from DSSInitializerFunction contains a default tooltip that describes how to open the menu, at "menuOpenToolTip"
		-- It's generally a good idea to use that one as a default!
		tooltip = dssmod.menuOpenToolTip,
	},
	items = {
		title = "items blacklist",

		buttons = InitDisableMenu(),
	},
	illusionsoptions = {
		title = "illusion options",
		buttons = {
			{
				strset = { "illusions can", "place bombs" },
				fsize = 2,
				choices = { "no", "yes" },
				setting = 1,
				variable = "IllusionClonesPlaceBombs",

				load = function()
					return IllusionMod.CanPlaceBomb and 2 or 1
				end,

				store = function(newOption)
					IllusionMod.CanPlaceBomb = newOption == 2
				end,

				tooltip = { strset = { "can illusions", "place bombs?" } },
			},
			{ str = "", nosel = true },
			{
				str = "perfect illusion",
				fsize = 2,
				choices = { "no", "yes" },
				setting = 1,
				variable = "PerfectIllusion",

				load = function()
					return IllusionMod.PerfectIllusion and 2 or 1
				end,

				store = function(newOption)
					IllusionMod.PerfectIllusion = newOption == 2
				end,

				tooltip = { strset = { "create perfect", "illusions for", "modded", "characters?" } },
			},
		},
	},
	settings = {
		title = "settings",
		buttons = {
			{ str = "", nosel = true },
			{
				str = "illusion options",
				dest = "illusionsoptions",
				tooltip = GenerateTooltip("tweaks for illusions"),
				fzise = 2,
			},
			{ str = "", nosel = true },
			{
				strset = { "max's head", "emojis" },
				fsize = 2,
				choices = { "no", "yes" },
				setting = 1,
				variable = "MaxsHeadsEmojis",

				load = function()
					return RestoredCollection:GetDefaultFileSave("MaxsHead") or 1
				end,

				store = function(newOption)
					RestoredCollection:AddDefaultFileSave("MaxsHead", newOption)
				end,

				tooltip = { strset = { "allow max's", "head emojis to", "appear when", "shooting tears" } },
			},
			{
				-- Creating gaps in your page can be done simply by inserting a blank button.
				-- The "nosel" tag will make it impossible to select, so it'll be skipped over when traversing the menu, while still rendering!
				str = "",
				fsize = 2,
				nosel = true,
			},
			dssmod.gamepadToggleButton,
			dssmod.menuKeybindButton,
			dssmod.paletteButton,
			dssmod.menuHintButton,
			dssmod.menuBuzzerButton,
		},
	},
}

local restoreditemsdirectorykey = {
	Item = restoreditemsdirectory.main, -- This is the initial item of the menu, generally you want to set it to your main item
	Main = "main", -- The main item of the menu is the item that gets opened first when opening your mod's menu.

	-- These are default state variables for the menu; they're important to have in here, but you don't need to change them at all.
	Idle = false,
	MaskAlpha = 1,
	Settings = {},
	SettingsChanged = false,
	Path = {},
}

--#region AgentCucco pause manager for DSS

local function DeleteParticles()
	for _, ember in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.FALLING_EMBER, -1)) do
		if ember:Exists() then
			ember:Remove()
		end
	end
	if REPENTANCE then
		for _, rain in ipairs(Isaac.FindByType(EntityType.ENTITY_EFFECT, EffectVariant.RAIN_DROP, -1)) do
			if rain:Exists() then
				rain:Remove()
			end
		end
	end
end

local OldTimer
local OldTimerBossRush
local OldTimerHush
local OverwrittenPause = false
local AddedPauseCallback = false
local function OverridePause(self, player, hook, action)
	if not AddedPauseCallback then
		return nil
	end

	if OverwrittenPause then
		OverwrittenPause = false
		AddedPauseCallback = false
		return
	end

	if action == ButtonAction.ACTION_SHOOTRIGHT then
		OverwrittenPause = true
		DeleteParticles()
		return true
	end
end
RestoredCollection:AddCallback(ModCallbacks.MC_INPUT_ACTION, OverridePause, InputHook.IS_ACTION_PRESSED)

local function FreezeGame(unfreeze)
	if unfreeze then
		OldTimer = nil
		OldTimerBossRush = nil
		OldTimerHush = nil
		if not AddedPauseCallback then
			AddedPauseCallback = true
		end
	else
		if not OldTimer then
			OldTimer = Game().TimeCounter
		end
		if not OldTimerBossRush then
			OldTimerBossRush = Game().BossRushParTime
		end
		if not OldTimerHush then
			OldTimerHush = Game().BlueWombParTime
		end

		Isaac.GetPlayer(0):UseActiveItem(CollectibleType.COLLECTIBLE_PAUSE, UseFlag.USE_NOANIM)

		Game().TimeCounter = OldTimer
		Game().BossRushParTime = OldTimerBossRush
		Game().BlueWombParTime = OldTimerHush
		DeleteParticles()
	end
end

local function RunRestoredItemsDSSMenu(tbl)
	FreezeGame()
	dssmod.runMenu(tbl)
end

local function CloseRestoredItemsDSSMenu(tbl, fullClose, noAnimate)
	FreezeGame(true)
	dssmod.closeMenu(tbl, fullClose, noAnimate)
end
--#endregion

DeadSeaScrollsMenu.AddMenu(modMenuName, {
	-- The Run, Close, and Open functions define the core loop of your menu
	-- Once your menu is opened, all the work is shifted off to your mod running these functions, so each mod can have its own independently functioning menu.
	-- The DSSInitializerFunction returns a table with defaults defined for each function, as "runMenu", "openMenu", and "closeMenu"
	-- Using these defaults will get you the same menu you see in Bertran and most other mods that use DSS
	-- But, if you did want a completely custom menu, this would be the way to do it!

	-- This function runs every render frame while your menu is open, it handles everything! Drawing, inputs, etc.
	Run = RunRestoredItemsDSSMenu,
	-- This function runs when the menu is opened, and generally initializes the menu.
	Open = dssmod.openMenu,
	-- This function runs when the menu is closed, and generally handles storing of save data / general shut down.
	Close = CloseRestoredItemsDSSMenu,

	Directory = restoreditemsdirectory,
	DirectoryKey = restoreditemsdirectorykey,
})

if REPENTOGON then
	InitImGuiMenu()
	UpdateImGuiMenu(false)

	local InGame = false

	local function UpdateImGuiOnRender()
		if not Isaac.IsInGame() and InGame then
			UpdateImGuiMenu(false)
			InGame = false
		elseif Isaac.IsInGame() and not InGame then
			UpdateImGuiMenu(true)
			InGame = true
		end
	end
	RestoredCollection:AddPriorityCallback(ModCallbacks.MC_POST_RENDER, CallbackPriority.LATE, UpdateImGuiOnRender)
	RestoredCollection:AddPriorityCallback(ModCallbacks.MC_MAIN_MENU_RENDER, CallbackPriority.LATE, UpdateImGuiOnRender)
end

include("lua.core.dss.changelog")
-- There are a lot more features that DSS supports not covered here, like sprite insertion and scroller menus, that you'll have to look at other mods for reference to use.
-- But, this should be everything you need to create a simple menu for configuration or other simple use cases!
