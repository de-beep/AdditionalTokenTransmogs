--Helper functions

-- Function to add value to table only if not present
function addIfNotExists(list, key, value)
   for _, v in pairs(list) do
      if v == value then
         return  -- already in the list, do nothing
      end
   end
   list[key] = value
end

-- function to get all unique appeareances from a list of items
function GetUniqueAppearances(items)
    local appearances = {}
   for _, item in ipairs(items) do
      local appearanceID, sourceId = C_TransmogCollection.GetItemInfo(item)
      addIfNotExists(appearances, item, appearanceID)
   end
   return appearances
end

-- Builds a table: item : collected
function GetCollectedSourcesFromId(itemId)
    collectedMapping = {}
    local appearances = GetUniqueAppearances(ItemData.Items[itemId])
    for item, appearanceID in pairs(appearances) do
         -- We need to search all sources to be sure, that a item is not already known
         local known = false
         local sources = C_TransmogCollection.GetAllAppearanceSources(appearanceID)
         for _, source in ipairs(sources) do
            if known then
               break
            end
            known = C_TransmogCollection.GetAppearanceSourceInfo(source).isCollected
         end

         collectedMapping[item] = known
    end
    return collectedMapping
end