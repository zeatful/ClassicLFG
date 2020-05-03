--  Declare Addon and embed libraries
ClassicLFG = LibStub("AceAddon-3.0"):NewAddon("ClassicLFG", "AceConsole-3.0", "AceEvent-3.0")
local AceGUI = LibStub("AceGUI-3.0")

-- Setup Options Config Table
local options = {
    name = "ClassicLFG",
    handler = ClassicLFG,
    type = 'group',
    args = {        
    }
}

local playerLevel = UnitLevel("player") -- grab player level
local playerClassIndex = UnitClass("player") -- grab player class
local playerClass = "None"
local isTank = false
local isHealer = false

-- table of roles
local roles = {}
roles[0] = "Tank"
roles[1] = "Healer"
roles[2] = "Dps"

-- class index reference from UnitClass
local classes = {}
classes[0] = "None"
classes[1] = "Warrior"
classes[2] = "Paladin"
classes[3] = "Hunter"
classes[4] = "Rogue"
classes[5] = "Priest"
classes[6] = "DeathKnight"
classes[7] = "Shaman"
classes[8] = "Mage"
classes[9] = "Warlock"
classes[10] = "Monk"
classes[11] = "Druid"
classes[12] = "Demon Hunter"

-- table of classes eligible to tank
local tankClasses = {}
tankClasses["Warrior"] = "Warrior"
tankClasses["Paladin"]= "Paladin"
tankClasses["Druid"] = "Druid"

-- table of classes eligible to healer
local healClasses = {}
healClasses["Priest"] = "Priest"
healClasses["Paladin"] = "Priest"
healClasses["Druid"] = "Druid"
healClasses["Shaman"] = "Shaman"

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

---- define UI elements ----
local appropriateLevelCheckbox = AceGUI:Create("CheckBox")
local roleDropDown = AceGUI:Create("Dropdown")
local instanceDropDown = AceGUI:Create("Dropdown")
local queueButton = AceGUI:Create("Button")

function ClassicLFG:Contains(set, key)
    return set[key] ~= nil
end

function ClassicLFG:OnInitialize()
    self:Print("ClassicLFG initializing!")
    -- Called when the addon is loaded
    LibStub("AceConfig-3.0"):RegisterOptionsTable("ClassicLFG", options)
    self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ClassicLFG", "ClassicLFG")
    self:RegisterChatCommand("lfg", "DisplayUI")
end

function ClassicLFG:OnEnable()
    self:Print("ClassicLFG loaded!")

    -- get player class
    playerClass = classes[playerClassIndex]
    
    -- determine if tank or healer possible
    isTank = self:Contains(tankClasses, playerClass)
    isHealer = self:Contains(healClasses, playerClass)

    self:Print("Can Tank? --> " .. tostring(isTank))
    self:Print("Can Heal? --> " .. tostring(isHealer))
end

function ClassicLFG:QueueForInstance()
    -- disable queue button
    -- grab selected instance and role
    -- need to send out a communication    
    self:Print("Queue for instance pressed!")
end

function ClassicLFG:CheckAppropriateLevelCheckBox()
    local checkedValue = appropriateLevelCheckbox:GetValue()
    self:Print("appropriateLevelCheckbox value changed --> " .. tostring(checkedValue))
    return checkedValue
end

-- set instance dropdown to a list of filtered instances
function ClassicLFG:SetInstancesForDropDown(dropdown)
    local filteredInstances = {}    

    -- for each instance, check if it is appropriate for the player based on min / max level, if so add it to the list
    local instance = {}
    local i = 0
    local checkAppropriateLevel = self:CheckAppropriateLevelCheckBox()
    local playerLessThanMax = false
    for k in pairs(instances) do        
        instance = instances[k];
        playerLessThanMax = (playerLevel <= instance.maxLevel)
        if(playerLevel >= instance.minLevel) then
            if(not checkAppropriateLevel or playerLessThanMax) then
                filteredInstances[k] = instance.name .. " (" .. instance.minLevel .. "-" .. instance.maxLevel .. ")"
            end
        end
    end

    dropdown:SetList(filteredInstances)
end

function ClassicLFG:DisplayUI()
    self:Print("ClassicLFG UI displayed!")
    -- Addon parent frame
    local parentFrame = AceGUI:Create("Frame")
    parentFrame:SetTitle("Classic LFG")
    parentFrame:SetStatusText("Classic LFG Queue Screen")
    parentFrame:SetCallback("OnClose", function(widget) AceGUI:Release(widget) end)
    parentFrame:SetLayout("List")

    appropriateLevelCheckbox:SetLabel("Only show appropriate instances based on level:")
    appropriateLevelCheckbox:SetCallback("OnValueChanged", function(value) self:SetInstancesForDropDown(instanceDropDown) end)
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

    self:SetInstancesForDropDown(instanceDropDown)
end