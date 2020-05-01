--------------------
--  Declare Libraries
--------------------
local AceGUI = LibStub("AceGUI-3.0")
local AceComm = LibStub("AceComm-3.0")

--------------------
--  Global Variables
--------------------
local parentFrame = AceGUI:Create("Frame")
local appropriateLevelCheckbox = AceGUI:Create("CheckBox")
local roleDropDown = AceGUI:Create("Dropdown")
local instanceDropDown = AceGUI:Create("Dropdown")
local queueButton = AceGUI:Create("Button")

-- table of roles
local roles = {}
roles[0] = "Tank"
roles[1] = "Healer"
roles[2] = "Dps"

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

--------------------
--  Functions
--------------------
local function QueueForInstance()
    -- disable queue button
    -- grab selected instance and role
    -- need to send out a communication    
end

local function CheckAppropriateLevelCheckBox()
    return appropriateLevelCheckbox:GetValue()
end

-- set instance dropdown to a list of filtered instances
local function SetInstancesForDropDown()
    local filteredInstances = {}
    local playerLevel = UnitLevel("player") -- grab player level

    -- for each instance, check if it is appropriate for the player based on min / max level, if so add it to the list
    local instance = {}
    local i = 0
    for k in pairs(instances) do        
        instance = instances[k];
        if(playerLevel >= instance.minLevel) then
            -- if((CheckAppropriateLevelCheckBox()) and (playerLevel <= instance.maxLevel)) then
            if(CheckAppropriateLevelCheckBox()) then
                filteredInstances[k] = instance.name .. " (" .. instance.minLevel .. "-" .. instance.maxLevel .. ")"
            end
        end
    end

    instanceDropDown:SetList(filteredInstances)
end

--------------------
-- UI Definition
--------------------
-- Addon parent frame
parentFrame:SetTitle("Classic LFG")
parentFrame:SetStatusText("Classic LFG Queue Screen")
parentFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
parentFrame:SetLayout("List")

appropriateLevelCheckbox:SetLabel("Only show appropriate instances based on level:")
appropriateLevelCheckbox:SetCallback("OnValueChanged", SetInstancesForDropDown)
parentFrame:AddChild(appropriateLevelCheckbox)

-- Role DropDown - Tank, Healer, Dps
roleDropDown:SetText("Select Role")
roleDropDown:SetList(roles)
parentFrame:AddChild(roleDropDown)

-- Instance DropDown, IE: Scholomance, Wailing Caverns, etc...
instanceDropDown:SetText("Select Instance")
parentFrame:AddChild(instanceDropDown)

-- Button to join the queue
queueButton:SetText("Queue")
queueButton:SetWidth(200)
parentFrame:AddChild(queueButton)