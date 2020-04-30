--------------------
--  Declare Libraries
--------------------
local AceGUI = LibStub("AceGUI-3.0")
local AceComm = LibStub("AceComm-3.0")

--------------------
--  Global Variables
--------------------

--------------------
--  Functions
--------------------
function QueueForInstance()
    -- disable queue button
    -- grab selected instance and role
    -- need to send out a communication    
end

-- Return a list of filtered instances for the dropdown, only the instance key and name
function SetInstancesForDropDown(table)
    local filteredInstances = {}
    local playerLevel = UnitLevel("player") -- grab player level

    -- for each instance, check if it is appropriate for the player based on min / max level, if so add it to the list
    local instance = {}
    local i = 0
    for k in pairs(table) do        
        instance = table[k];
        if(playerLevel >= instance.minLevel) then
            if((not CheckAppropriateLevelCheckBox()) and (playerLevel <= instance.maxLevel)) then
                filteredInstances[k] = instance.name .. " (" .. instance.minLevel .. "-" .. instance.maxLevel .. ")"
            end
        end
    end

    -- return a list of instances filtered by player level, containing only the instance key and name
    return filteredInstances
end

function CheckAppropriateLevelCheckBox()
    return appropriateLevelCheckbox:GetValue()
end

--------------------
-- UI Definition
--------------------
-- Addon parent frame
local frame = AceGUI:Create("Frame")
frame:SetTitle("Classic LFG")
frame:SetStatusText("Classic LFG Queue Screen")
frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
frame:SetLayout("List")

local appropriateLevelCheckbox = AceGUI:Create("CheckBox")
appropriateLevelCheckbox:SetLabel("Only show appropriate instances based on level:")
frame:AddChild(appropriateLevelCheckbox)

-- table of roles
local roles = {}
roles[0] = "Tank"
roles[1] = "Healer"
roles[2] = "Dps"

-- Role DropDown - Tank, Healer, Dps
local roleDropDown = AceGUI:Create("Dropdown")
roleDropDown:SetText("Select Role")
roleDropDown:SetList(roles)
frame:AddChild(roleDropDown)

-- table of instances : key, name, minimum level and maximum level
local instances = {}
instances[0] = { name = "Ragefire Chasm", minLevel = 13, maxLevel = 18}
instances[1] = { name = "Wailing Caverns", minLevel = 17, maxLevel = 24}
instances[2] = { name = "The Deadmines", minLevel = 17, maxLevel = 26}
instances[3] = { name = "Shadowfang Keep", minLevel = 22, maxLevel = 30}
instances[4] = { name = "Blackfathom Deeps", minLevel = 24, maxLevel = 32}
instances[5] = { name = "The Stockade", minLevel = 24, maxLevel = 32}
instances[6] = { name = "Gnomeregan", minLevel = 29, maxLevel = 38}
instances[7] = { name = "Razorfen Kraul", minLevel = 29, maxLevel = 38}
instances[8] = { name = "The Scarlet Monastery", minLevel = 34, maxLevel = 45}
instances[9] = { name = "Razorfen Downs", minLevel = 37, maxLevel = 46}
instances[10] = { name = "Uldaman", minLevel = 41, maxLevel = 51}
instances[11] = { name = "Zul’Farrak", minLevel = 42, maxLevel = 46}
instances[12] = { name = "Maraudon", minLevel = 46, maxLevel = 55}
instances[13] = { name = "Temple of Atal’Hakkar", minLevel = 50, maxLevel = 56}
instances[14] = { name = "Blackrock Depths", minLevel = 52, maxLevel = 60}
instances[15] = { name = "Lower Blackrock Spire", minLevel = 55, maxLevel = 60}
instances[16] = { name = "Dire Maul", minLevel = 55, maxLevel = 60}
instances[17] = { name = "Stratholme", minLevel = 58, maxLevel = 60}
instances[18] = { name = "Scholomance", minLevel = 58, maxLevel = 60}

-- Instance DropDown, IE: Scholomance, Wailing Caverns, etc...
local instanceDropDown = AceGUI:Create("Dropdown")
instanceDropDown:SetText("Select Instance")
local sortedInstances = SetInstancesForDropDown(instances)
instanceDropDown:SetList(sortedInstances)
frame:AddChild(instanceDropDown)

-- Button to join the queue
local queueButton = AceGUI:Create("Button")
queueButton:SetText("Queue")
queueButton:SetWidth(200)
frame:SetStatusText("OnClick", QueueForInstance())
frame:AddChild(queueButton)