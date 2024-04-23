-- SWEP LIBRARY CONFIGURATION
-- STEAM: greek freak
-- GITHUB: dLL44

local config = {
    PrintName = nil,
    Purpose = nil,
    Author = nil,
    Instructions = nil,
    Category = nil,
    Spawnable = nil,
    AdminOnly = nil,
    Icon = nil,
    KillIcon = nil,
    cModel = nil,
    drawCrossHair = nil,
    drawAmmo = nil,
    flipModel = nil,
    fov = nil,
    useHands = nil,
    wModel = nil,
    holdType = nil,
    csMuzzle = nil,
    slot = nil,
    slotPos = nil,
    weight = nil,
    autoSwitchTo = nil,
    autoSwitchFrom = nil,
    fireUnderwater = nil,
    PRIM_onOff = nil,
    PRIM_damage = nil,
    PRIM_takeAmmo = nil,
    PRIM_clipSize = nil,
    PRIM_ammoType = nil,
    PRIM_defaultClip = nil,
    PRIM_spread = nil,
    PRIM_numberOfShots = nil,
    PRIM_auto = nil,
    PRIM_recoil = nil,
    PRIM_delay = nil,
    PRIM_force = nil,
    PRIM_shootSound = nil,
    SEC_onOff = nil,
    SEC_damage = nil,
    SEC_takeAmmo = nil,
    SEC_clipSize = nil,
    SEC_ammoType = nil,
    SEC_defaultClip = nil,
    SEC_spread = nil,
    SEC_numberOfShots = nil,
    SEC_auto = nil,
    SEC_recoil = nil,
    SEC_delay = nil,
    SEC_force = nil,
    SEC_shootSound = nil,
    reloadSount = nil,
    reloadAct = nil
}

function EDIT(...)
    local args = {...}
    local numArgs = #args

    if numArgs % 2 ~= 0 then
        print("SweetSwep::ERROR:: Uneven number of arguments provided for EDIT")
        return
    end

    for i = 1, numArgs, 2 do
        local key = args[i]
        local value = args[i + 1]
        config[key] = value
    end
end

function GET(...)
    local result = {}
    for _, var in ipairs({...}) do
        result[var] = config[var] or "Variable not found"
    end
    return result
end

function INIT()
    -- Set default values for configurations
    config.PrintName = "SweeSwep_SWEP"
    config.Purpose = "Default Purpose for SweeSwep Lib"
    config.Author = "greek freak"
    config.Instructions = "Anything"
    config.Category = "Other"
    config.Spawnable = true
    config.AdminOnly = false
    config.Icon = ""
    config.KillIcon = ""
    config.cModel = "models/weapons/cstrike/c_rif_galil.mdl"
    config.drawCrosshair = true
    config.drawAmmo = true
    config.flipModel = false
    config.fov = 90
    config.useHands = true
    config.wModel = "models/weapons/w_rif_galil.mdl"
    config.holdType = "knife"
    config.csMuzzle = true
    config.slot = 1
    config.slotPos = 1
    config.weight = 5
    config.autoSwitchTo = false
    config.autoSwitchFrom = false
    config.fireUnderwater = true
    config.PRIM_onOff = true
    config.PRIM_damage = 10
    config.PRIM_takeAmmo = 1
    config.PRIM_clipSize = 30
    config.PRIM_ammoType = "GaussEnergy"
    config.PRIM_defaultClip = 30
    config.PRIM_spread = 0.02
    config.PRIM_numberOfShots = 1
    config.PRIM_auto = true
    config.PRIM_recoil = 1
    config.PRIM_delay = 0.1
    config.PRIM_force = 1000
    config.PRIM_shootSound = Sound("/tools/ifm/beep.wav")
    config.SEC_onOff = false
    config.SEC_damage = 20
    config.SEC_takeAmmo = 1
    config.SEC_clipSize = 20
    config.SEC_ammoType = "GaussEnergy"
    config.SEC_defaultClip = 20
    config.SEC_spread = 0.03
    config.SEC_numberOfShots = 1
    config.SEC_auto = false
    config.SEC_recoil = 2
    config.SEC_delay = 0.2
    config.SEC_force = 1500
    config.SEC_shootSound = Sound("/tools/ifm/beep.wav")
    config.reloadSound = Sound("/tools/ifm/postroll.wav")
    config.reloadAct = ACT_VM_RELOAD
end

return {
    edit = EDIT,
    get = GET,
    init = INIT
}
