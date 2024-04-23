-- SWEP LIBRARY FUNCTIONS
-- STEAM: greek freak
-- GITHUB: dLL44

CONF = require("ssconfig")

function SSMSG(type, message)
    if type == "e" then
        print("SweetSwep::ERROR:: " .. message)
    elseif type == "w" then
        print("SweetSwep::WARN:: " .. message)
    elseif type ==  "i" then
        print("SweetSwep::INFO:: " .. message)
    else
        print("SweetSwep::ERROR:: SSMSG Type not Found, No Message Printed")
        return false
    end
    return true
end

function SSINIT()
    CONF:INIT()
end

function SSPRECACHE(...)
    for _, asset in ipairs({...}) do
        if type(asset) == "string" then
            util.PrecacheSound(asset)
        elseif type(asset) == "table" then
            for _, path in ipairs(asset) do
                if type(path) == "string" then
                    if string.find(path, "%.wav") or string.find(path, "%.mp3") then
                        util.PrecacheSound(path)
                    elseif string.find(path, "%.vmt") then
                        util.PrecacheMaterial(path)
                    elseif string.find(path, "%.mdl") then
                        util.PrecacheModel(path)
                    end
                end
            end
        end
    end
end

function SetUpSwep(swep)
    if CONF:GET("PRIM_onOff") then
        function swep:PrimaryAttack()
            if ( !swep:CanPrimaryAttack() ) then return end

            local bullet = {}
            bullet.Num = CONF:GET("PRIM_numberOfShots")
            bullet.Src = swep.Owner:GetShootPos()
            bullet.Dir = swep.Owner:GetAimVector()
            bullet.Spread = Vector( CONF:GET("PRIM_spread") * 0.1 , CONF:GET("PRIM_spread") * 0.1, 0)
            bullet.Tracer = 1
            bullet.Force = CONF:GET("PRIM_force")
            bullet.Damage = CONF:GET("PRIM_damage")
            bullet.AmmoType = CONF:GET("PRIM_ammoType")

            local rnda = CONF:GET("PRIM_recoil") * -1
            local rndb = CONF:GET("PRIM_recoil") * math.random(-1, 1)

            swep:ShootEffects()

            swep.Owner:FireBullets( bullet )
            swep:EmitSound(CONF:GET("PRIM_shootSound"))
            swep.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
            swep:TakePrimaryAmmo(CONF:GET("PRIM_takeAmmo"))

            swep:SetNextPrimaryFire( CurTime() + CONF:GET("PRIM_delay") )

        end
    end
    if CONF:GET("SEC_onOff") then
        function swep:SecondaryAttack()
            if ( !swep:CanSecondaryAttack() ) then return end

            local bullet = {}
            bullet.Num = CONF:GET("SEC_numberOfShots")
            bullet.Src = swep.Owner:GetShootPos()
            bullet.Dir = swep.Owner:GetAimVector()
            bullet.Spread = Vector( CONF:GET("SEC_spread") * 0.1 , CONF:GET("SEC_spread") * 0.1, 0)
            bullet.Tracer = 1
            bullet.Force = CONF:GET("SEC_force")
            bullet.Damage = CONF:GET("SEC_damage")
            bullet.AmmoType = CONF:GET("SEC_ammoType")

            local rnda = CONF:GET("SEC_recoil") * -1
            local rndb = CONF:GET("SEC_recoil") * math.random(-1, 1)

            swep:ShootEffects()

            swep.Owner:FireBullets( bullet )
            swep:EmitSound(CONF:GET("SEC_shootSound"))
            swep.Owner:ViewPunch( Angle( rnda,rndb,rnda ) )
            swep:TakeSecondaryAmmo(CONF:GET("SEC_takeAmmo"))

            swep:SetNextSecondaryFire( CurTime() + CONF:GET("SEC_delay") )

        end
    end
    if CONF:GET("reloadSound") and CONF:GET("reloadAct") then
        function swep:Reload()
            swep:EmitSound(CONF:GET("reloadSound"))
            swep.Weapon:DefaultReload(ACT_VM_RELOAD)
        end
    end
    function swep.Initialize()
        SSPRECACHE(
            CONF:GET("PRIM_shootSound"),
            CONF:GET("SEC_shootSound"),
            CONF:GET("reloadSound"),
            CONF:GET("holdType")
        )
    end
end

function SetInfo(printName, purpose, author, instructions, category, spawnable, adminOnly)
    if not (printName and purpose and author and instructions and category and spawnable and adminOnly) then
        SSMSG("e", "Not Enough Info Provided for SetInfo")
    else
        CONF:EDIT(
            "PrintName", printName,
            "Purpose", purpose,
            "Author", author,
            "Instructions", instructions,
            "Category", category,
            "Spawnable", spawnable,
            "AdminOnly", adminOnly)
    end
end

-- GRAPHICS
Graphics = {}

function Graphics.SetIcon(materialIconPath, mode)
    if materialIconPath then
        if mode == "icon" then
            CONF:EDIT("Icon", materialIconPath)
        elseif mode == "killicon" then
            CONF:EDIT("KillIcon", materialIconPath)
        else
            SSMSG("e", "Invalid mode for SetIcon")
        end
    else
        SSMSG("e", "Missing materialIconPath for SetIcon")
    end
end

-- MODELS
Models = {}

function Models.SetViewModel(viewModel)
    if viewModel then
        CONF:EDIT("cModel", viewModel)
    else
        SSMSG("e", "Missing viewModel or Invalid Param for SetViewModel")
    end
end

function Models.SetWorldModel(worldModel)
    if worldModel then
        CONF:EDIT("wModel", worldModel)
    else
        SSMSG("e", "Missing worldModel or Invalid Param for SetWorldModel")
    end
end

function Models.SetViewModelInfo(drawCrosshair, drawAmmo, flipModel, fov, useHands)
    if drawCrosshair and drawAmmo and flipModel and fov and useHands then
        CONF:EDIT(
            "drawCrosshair", drawCrosshair,
            "drawAmmo", drawAmmo,
            "flipModel", flipModel,
            "fov", fov,
            "useHands", useHands
        )
    else
        SSMSG("e", "Missing or Invalid Param for SetViewModelInfo")
    end
end

function Models.SetWorldModelInfo(holdType, csMuzzleFlashes)
    if holdType and csMuzzleFlashes then
        CONF:EDIT(
            "holdType", holdType,
            "csMuzzle", csMuzzleFlashes
        )
    else
        SSMSG("e", "Missing or Invaild Param for SetWorldModelInfo")
    end
end

-- GUN
Gun = {}

function Gun.SetInfo(slot, slotPos, weight, autoSwitchTo, autoSwitchFrom, fireUnderwater)
    if slot and slotPos and weight and autoSwitchTo and autoSwitchFrom and fireUnderwater then
        CONF:EDIT(
            "slot", slot,
            "slotPos", slotPos,
            "weight", weight,
            "autoSwitchTo", autoSwitchTo,
            "autoSwitchFrom", autoSwitchFrom,
            "fireUnderwater", fireUnderwater
        )
    else
        SSMSG("e", "Missing or Invaild Param for Gun.SetInfo")
    end
end

--[[
    onOff,
    damage,
    takeAmmo,
    clipSize,
    ammoType,
    defaultClip,
    spread,
    numberOfShots,
    auto,
    recoil,
    delay,
    force
]]--
function Gun.SetPrimaryFire(onOff, damage, takeAmmo, clipSize, ammoType, defaultClip, spread, numberOfShots, auto, recoil, delay, force, shootSound)
    if onOff and damage and takeAmmo and clipSize and ammoType and defaultClip and spread and numberOfShots and auto and recoil and delay and force and shootSound then
        CONF:EDIT(
            "PRIM_onOff", onOff,
            "PRIM_damage", damage,
            "PRIM_takeAmmo", takeAmmo,
            "PRIM_clipSize", clipSize,
            "PRIM_ammoType", ammoType,
            "PRIM_defaultClip", defaultClip,
            "PRIM_spread", spread,
            "PRIM_numberOfShots", numberOfShots,
            "PRIM_auto", auto,
            "PRIM_recoil", recoil,
            "PRIM_delay", delay,
            "PRIM_force", force,
            "PRIM_shootSound", shootSound
        )
    else
        SSMSG("e", "Missing or Invaild Param for SetPrimaryFire")
    end
end

function Gun.SetSecondaryFire(onOff, damage, takeAmmo, clipSize, ammoType, defaultClip, spread, numberOfShots, auto, recoil, delay, force, shootSound)
    if onOff and damage and takeAmmo and clipSize and ammoType and defaultClip and spread and numberOfShots and auto and recoil and delay and force and shootSound then
        CONF:EDIT(
            "SEC_onOff", onOff,
            "SEC_damage", damage,
            "SEC_takeAmmo", takeAmmo,
            "SEC_clipSize", clipSize,
            "SEC_ammoType", ammoType,
            "SEC_defaultClip", defaultClip,
            "SEC_spread", spread,
            "SEC_numberOfShots", numberOfShots,
            "SEC_auto", auto,
            "SEC_recoil", recoil,
            "SEC_delay", delay,
            "SEC_force", force,
            "SEC_shootSound", shootSound
        )
    else
        SSMSG("e", "Missing or Invaild Param for SetSecondaryFire")
    end
end

function Gun.SetReload(sound, act)
    if sound and act then
        CONF:EDIT(
            "reloadSound", sound,
            "reloadAct", act
        )
    end
end

function Gun.SetSWEPTable()
    return {
        PrintName = CONF:get("PrintName"),
        Purpose = CONF:get("Purpose"),
        Author = CONF:get("Author"),
        Category = CONF:get("Category"),
        Spawnable = CONF:get("Spawnable"),
        AdminOnly = CONF:get("AdminOnly"),
        Icon = CONF:get("Icon"),
        KillIcon = CONF:get("KillIcon"),
        ViewModel = CONF:get("cModel"),
        WorldModel = CONF:get("wModel"),
        DrawCrosshair = CONF:get("drawCrosshair"),
        DrawAmmo = CONF:get("drawAmmo"),
        Weight = CONF:get("weight"),
        AutoSwitchTo = CONF:get("autoSwitchTo"),
        AutoSwitchFrom = CONF:get("autoSwitchFrom"),
        Slot = CONF:get("slot"),
        SlotPos = CONF:get("slotPos"),
        HoldType = CONF:get("holdType"),
        FiresUnderwater = CONF:get("fireUnderwater"),
        Primary = {
            Damage = CONF:get("PRIM_damage"),
            TakeAmmo = CONF:get("PRIM_takeAmmo"),
            ClipSize = CONF:get("PRIM_clipSize"),
            AmmoType = CONF:get("PRIM_ammoType"),
            DefaultClip = CONF:get("PRIM_defaultClip"),
            Spread = CONF:get("PRIM_spread"),
            NumberOfShots = CONF:get("PRIM_numberOfShots"),
            Automatic = CONF:get("PRIM_auto"),
            Recoil = CONF:get("PRIM_recoil"),
            Delay = CONF:get("PRIM_delay"),
            Force = CONF:get("PRIM_force"),
            ShootSound = CONF:get("PRIM_shootSound")
        },
        Secondary = {
            Damage = CONF:get("SEC_damage"),
            TakeAmmo = CONF:get("SEC_takeAmmo"),
            ClipSize = CONF:get("SEC_clipSize"),
            AmmoType = CONF:get("SEC_ammoType"),
            DefaultClip = CONF:get("SEC_defaultClip"),
            Spread = CONF:get("SEC_spread"),
            NumberOfShots = CONF:get("SEC_numberOfShots"),
            Automatic = CONF:get("SEC_auto"),
            Recoil = CONF:get("SEC_recoil"),
            Delay = CONF:get("SEC_delay"),
            Force = CONF:get("SEC_force"),
            ShootSound = CONF:get("SEC_shootSound")
        },
        ReloadSound = CONF:get("reloadSound"),
        ReloadAct = CONF:get("reloadAct")
    }
end