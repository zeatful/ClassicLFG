--------------------
--  UI Setup
--------------------
local AceGUI = LibStub("AceGUI-3.0")
local AceComm = LibStub("AceComm-3.0")

-- Addon parent frame
local frame = AceGUI:Create("Frame")
frame:SetTitle("Classic LFG")
frame:SetStatusText("Classic LFG Queue Screen")
frame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
frame:SetLayout("Flow")

-- table of roles
local roles = {}
roles[T] = "Tank"
roles[H] = "Healer"
roles[D] = "Dps"

-- Role DropDown - Tank, Healer, Dps
local roleDropDown = AceGUI:Create("DropDown")
roleDropDown:SetText("Select Role")
roleDropDown.SetList(roles)
frame:AddChild(roleDropDown)

-- table of instances : key, name, minimum level and maximum level
local instances = {
    [RFC] = { name = {"Ragefire Chasm"}, minLevel = {"13"}, maxLevel = {"18"}},
    [WC] = { name = {"Wailing Caverns"}, minLevel = {"17"}, maxLevel = {"24"}},
    [VC] = { name = {"The DeadminLeveles"}, minLevel = {"17"}, maxLevel = {"26"}},
    [SFK] = { name = {"Shadowfang Keep"}, minLevel = {"22"}, maxLevel = {"30"}},
    [BFD] = { name = {"Blackfathom Deeps"}, minLevel = {"24"}, maxLevel = {"32"}},
    [STOCK] = { name = {"The Stockade"}, minLevel = {"24"}, maxLevel = {"32"}},
    [GNOME] = { name = {"Gnomeregan"}, minLevel = {"29"}, maxLevel = {"38"}},
    [RFK] = { name = {"Razorfen Kraul"}, minLevel = {"29"}, maxLevel = {"38"}},
    [SM] = { name = {"The Scarlet Monastery"}, minLevel = {"34"}, maxLevel = {"45"}},
    [RFD] = { name = {"Razorfen Downs"}, minLevel = {"37"}, maxLevel = {"46"}},
    [ULD] = { name = {"Uldaman"}, minLevel = {"41"}, maxLevel = {"51"}},
    [ZF] = { name = {"Zul’Farrak"}, minLevel = {"42"}, maxLevel = {"46"}},
    [MARA] = { name = {"Maraudon"}, minLevel = {"46"}, maxLevel = {"55"}},
    [ST] = { name = {"Temple of Atal’Hakkar"}, minLevel = {"50"}, maxLevel = {"56"}},
    [BRD] = { name = {"Blackrock Depths"}, minLevel = {"52"}, maxLevel = {"60"}},
    [LBRS] = { name = {"Lower Blackrock Spire"}, minLevel = {"55"}, maxLevel = {"60"}},
    [DM] = { name = {"Dire Maul"}, minLevel = {"55"}, maxLevel = {"60"}},
    [STRAT] = { name = {"Stratholme"}, minLevel = {"58"}, maxLevel = {"60"}},
    [SCHOLO] = { name = {"Scholomance"}, minLevel = {"58"}, maxLevel = {"60"}}
}

-- Instance DropDown, IE: Scholomance, Wailing Caverns, etc...
local instanceDropDown = AceGUI:Create("DropDown")
instanceDropDown:SetText("Select Instance")
instanceDropDown:SetList(SetInstancesForDropDown(instances, instanceDropDown))
frame:AddChild(instanceDropDown)

-- Button to join the queue
local queueButton = AceGUI:Create("Button")
queueButton:SetText("Queue")
queueButton:SetWidth(200)
frame:SetStatusText("OnClick", QueueForInstance())
frame:AddChild(queueButton)

--------------------
--  Functions
--------------------
local function QueueForInstance()
    -- disable queue button
    -- grab selected instance and role
    -- need to send out a communication    
end

-- Return a list of filtered instances for the dropdown, only the instance key and name
local function SetInstancesForDropDown(table, instanceDropDown)
    local filteredInstances = {}
    local playerLevel = UnitLevel("player") -- grab player level

    -- for each instance, check if it is appropriate for the player based on min / max level, if so add it to the list
    local instance = {}
    for k in pairs(table) do        
        instance = table[k];
        if( playerLevel <= instance.maxLevel and playerLevel >= instance.minLevel) then
            filteredInstances[k] = instance.name
        end
    end

    -- return a list of instances filtered by player level, containing only the instance key and name
    return filteredInstances
end