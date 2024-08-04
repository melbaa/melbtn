local TOGGLEBB_BTN_ID = 4

local melbtn = CreateFrame("Frame")


local function print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("melbtn: " .. msg)
end

local function display(msg)
    if MikSBT.DisplayMessage then
        MikSBT.DisplayMessage(msg, nil, false, .2, .7, .9)
    end
    print(msg)
end

local font_size = 14;

local function togglebb_read(tn)
    local btn = getglobal('melbtn' .. TOGGLEBB_BTN_ID)
    if VCB_SAVE["MISC_disable_BB"] then
        display("dpsing - not cancelling buffs")
        btn.txt:SetText("dpsing")
    else
        display("tanking - cancelling buffs")
        btn.txt:SetText("tanking")
    end
end
local function togglebb(btn)
    if VCB_SAVE["MISC_disable_BB"] then
        VCB_SAVE["MISC_disable_BB"] = false
        display("tanking - cancelling buffs")
        btn.txt:SetText("tanking")
    else
        VCB_SAVE["MISC_disable_BB"] = true
        display("dpsing - not cancelling buffs")
        btn.txt:SetText("dpsing")
    end
end

local function btncallback(btn)
    local i = btn.i
    if i == 1 then
        local cmd = "wear anni_nogear"
        display(cmd)
        OutfitterStack_Clear()
        Outfitter_ExecuteCommand(cmd)
    elseif i == 2 then
        local cmd = "wear udtrink"
        display(cmd)
        OutfitterStack_Clear()
        Outfitter_ExecuteCommand(cmd)
    elseif i == 3 then
        local cmd = 'wear dpstrink'
        display(cmd)
        OutfitterStack_Clear()
        Outfitter_ExecuteCommand(cmd)
    elseif i == TOGGLEBB_BTN_ID then
        togglebb(btn)
    elseif i == 5 then
        local cmd = "wear NAXX_dps_saph"
        display(cmd)
        OutfitterStack_Clear()
        Outfitter_ExecuteCommand(cmd)
    elseif i == 6 then
        local cmd = "wear NAXX_miti_4hm_backline"
        display(cmd)
        OutfitterStack_Clear()
        Outfitter_ExecuteCommand(cmd)
    elseif i == 7 then
        display('need')
        ChatFrame1Tab:Click()
        SlashCmdList["TOPMEOFF"]('ls need')
    end
end



local function createbtn(i, btnname)
    local btn = CreateFrame("Frame","melbtn" .. i,UIParent)
    btn.i = i
    local backdrop = {
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        tile="false",
        tileSize="8",
        edgeSize="8",
        insets={
            left="2",
            right="2",
            top="2",
            bottom="2"
        }
    }

    -- Frame
    local dimwidth = 30; btn:SetWidth(dimwidth);
    local dimheight = 15; btn:SetHeight(dimheight);
    btn:SetMovable(1); btn:EnableMouse(1);
    btn:SetPoint("CENTER", UIParent, "CENTER", 0, 0);
    btn:SetFrameStrata("BACKGROUND")
    btn:SetBackdrop(backdrop)
    btn:SetBackdropColor(0,0,0,1)
    btn:SetScale(1)
    btn:SetAlpha(1)

    -- Moving the frame
    btn:SetScript("OnMouseDown", function()
        if IsShiftKeyDown() then
            if arg1 == "LeftButton" then this:StartMoving()
            elseif arg1 == "RightButton" then this:StartMoving() end
        end
        btncallback(this)
    end)
    btn:SetScript("OnMouseUp", function() this:StopMovingOrSizing() end)
    btn:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)

    -- txt
    local txt = btn:CreateFontString();
    btn.txt = txt
    txt:SetFontObject(GameFontNormal);
    txt:SetPoint("Topleft", btn, "Topleft", 1, -1);
    txt:SetJustifyH("LEFT")
    txt:SetJustifyV("TOP")

    local font, size, flags = GameFontNormal:GetFont();
    txt:SetFont(font, font_size, "OUTLINE");
    txt:SetText(btnname)
end





local INIT2_NAME = 'melbtn_init2'
local function melbtn_init2()
    if VCB_IS_LOADED then
        togglebb_read()
        Chronos.unscheduleRepeating(INIT2_NAME)
    end
end


-- melbtn:RegisterEvent("ADDON_LOADED")
melbtn:RegisterEvent("VARIABLES_LOADED")
melbtn:SetScript("OnEvent", function()
    if event == 'VARIABLES_LOADED' then
        createbtn(1, "anni")
        createbtn(2, "udtrink")
        createbtn(3, "dpstrink")
        createbtn(TOGGLEBB_BTN_ID, "togglebb")
        createbtn(5, "saph")
        createbtn(6, "4hm")
        createbtn(7, "need")
    end

    Chronos.scheduleRepeating(INIT2_NAME, 1, melbtn_init2)
end)
