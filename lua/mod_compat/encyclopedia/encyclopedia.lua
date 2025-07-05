if not Encyclopedia then
	return
end

local Wiki = include("lua.mod_compat.encyclopedia.wiki")

local classname = "Restored Mods"
local modname = "Restored Items"

local items = Wiki.Items
table.sort(items, function(a,b) return a.ID < b.ID end)

for _, item in pairs(items) do
	Encyclopedia.AddItem({
		ModName = modname,
		Class = classname,
		Name = item.Name,
		ID = item.ID,
		WikiDesc = item.WikiDesc,
		Pools = item.Pools,
	})
end

for _, trinket in pairs(Wiki.Trinkets) do
	Encyclopedia.AddTrinket({
		ModName = modname,
		Class = classname,
		Name = trinket.Name,
		ID = trinket.ID,
		WikiDesc = trinket.WikiDesc,
	})
end

if Sewn_API then
	Sewn_API:AddEncyclopediaUpgrade(
		RestoredCollection.Enums.Familiars.CHECKED_MATE.Variant,
		"Increases damage",
		"Increases damage further and range"
	)
end

if Sewn_API then
	Sewn_API:AddEncyclopediaUpgrade(
		FamiliarVariant.MENORAH,
		"Higher fire rate per flame",
		"Higher fire rate per flame. You can keep firing even with no flames"
	)
end

--Hide
for i = 1, 5 do
	Encyclopedia.AddItem({
		ModName = modname,
		Class = classname,
		Name = Wiki.Items.LunchBox.Name,
		ID = Wiki.Items.LunchBox.ID - i,
		WikiDesc = Wiki.Items.LunchBox.WikiDesc,
		Pools = Wiki.Items.LunchBox.Pools,
		Hide = true,
	})
end

local TransformationItems = {
	Isaac.GetItemIdByName("Spun transform"),
	Isaac.GetItemIdByName("Mom transform"),
	Isaac.GetItemIdByName("Guppy transform"),
	Isaac.GetItemIdByName("Fly transform"),
	Isaac.GetItemIdByName("Bob transform"),
	Isaac.GetItemIdByName("Mushroom transform"),
	Isaac.GetItemIdByName("Baby transform"),
	Isaac.GetItemIdByName("Angel transform"),
	Isaac.GetItemIdByName("Devil transform"),
	Isaac.GetItemIdByName("Poop transform"),
	Isaac.GetItemIdByName("Book transform"),
	Isaac.GetItemIdByName("Spider transform"),
}

for _, item in ipairs(TransformationItems) do
	Encyclopedia.AddItem({
		ModName = modname,
		Class = classname,
		ID = item,
		Hide = true,
	})
end

RestoredCollection.Enums.Wiki = Wiki
