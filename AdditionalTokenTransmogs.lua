local RARITY_COLORS = {
    [0] = "|cff9d9d9d", -- Poor
    [1] = "|cffffffff", -- Common
    [2] = "|cff1eff00", -- Uncommon
    [3] = "|cff0070dd", -- Rare
    [4] = "|cffa335ee", -- Epic
    [5] = "|cffff8000", -- Legendary
    [6] = "|cffe6cc80", -- Artifact
}

collectedIcon = "|TInterface\\Buttons\\UI-CheckBox-Check:16:16|t"
notCollectedIcon = "|TInterface\\Buttons\\UI-CheckBox-UnCheck:16:16|t"

local function OnTooltipSetItem(tooltip)
   if not tooltip or not tooltip.GetItem then return end;
   local _, itemLink = tooltip:GetItem();
   if not itemLink then return end;

   -- Check if item id is in data
   local itemId = tonumber(strmatch(itemLink, "item:(%d+)"));
   if not ItemData.Items[itemId] then return end;

    tooltip:AddLine("Additional token transmogs")
    local collectedMapping = GetCollectedSourcesFromId(itemId)
    for item, collected in pairs(collectedMapping) do

        -- Get item information
        local itemName, itemSourceLink, rarity, _, _, _, armorType = GetItemInfo(item)
        if not itemName then return end;
        if not itemSourceLink then return end;
        if not armorType then return end;
        if not rarity then return end;

        -- Color the name according to rarity
        local color = RARITY_COLORS[itemRarity] or "|cffffffff"
        local displayName = color .. itemName .. "|r"

        -- Second column: collected + armor type
        local statusIcon = collected and collectedIcon or notCollectedIcon
        local armorText = armorType or ""
        local secondColumnText = string.format("%s %8s", statusIcon, armorText)

        tooltip:AddDoubleLine(itemSourceLink, secondColumnText)
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem);