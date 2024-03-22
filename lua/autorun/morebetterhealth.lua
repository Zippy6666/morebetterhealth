if CLIENT then
    function MissingConvMsg()
        local frame = vgui.Create("DFrame")
        frame:SetSize(300, 125)
        frame:SetTitle("Missing Library!")
        frame:Center()
        frame:MakePopup()

        local text = vgui.Create("DLabel", frame)
        text:SetText("This server does not have the CONV library installed, some addons may function incorrectly. Click the link below to get it:")
        text:Dock(TOP)
        text:SetWrap(true)  -- Enable text wrapping for long messages
        text:SetAutoStretchVertical(true)  -- Allow the text label to stretch vertically
        text:SetFont("BudgetLabel")

        local label = vgui.Create("DLabelURL", frame)
        label:SetText("CONV Library")
        label:SetURL("https://steamcommunity.com/sharedfiles/filedetails/?id=3146473253")
        label:Dock(BOTTOM)
        label:SetContentAlignment(5)  -- 5 corresponds to center alignment
    end
elseif SERVER && !file.Exists("convenience/adam.lua", "LUA") then
    -- Conv lib not on on server, send message to clients
    hook.Add("PlayerInitialSpawn", "convenienceerrormsg", function( ply )
        local sendstr = 'MissingConvMsg()'
        ply:SendLua(sendstr)
    end)
end


--[[
=======================================================================================================================
                                            Cvars
=======================================================================================================================
--]]


local Flags = bit.bor(FCVAR_ARCHIVE, FCVAR_REPLICATED)
local ArmorOnSpawn = CreateConVar("mbh_armor_on_spawn", "1", Flags)
local MedkitOnSpawn = CreateConVar("mbh_medkit_on_spawn", "1", Flags) 
local MaxHealthAndArmor = CreateConVar("mbh_max_hparmor", "125", Flags) 

--[[
=======================================================================================================================
                                            Server hooks
=======================================================================================================================
--]]


if SERVER then

    hook.Add("PlayerSpawn", "morebetterhealth", function( ply )

        local val = MaxHealthAndArmor:GetInt()


        -- Max armor
        ply:CallNextTick("SetMaxArmor", val)


        -- Fill armor if that option is enabled
        if ArmorOnSpawn:GetBool() then
            ply:CallNextTick("SetArmor", val)
        end


        -- Max health
        ply:CallNextTick("SetMaxHealth", val)
        ply:CallNextTick("SetHealth", val)


        -- Give medkit
        if MedkitOnSpawn:GetBool() then
            ply:Give("weapon_medkit")
        end

    end)

end