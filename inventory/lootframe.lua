local _, GW = ...

local function updateLootFrameButtons()
    for i=1,4 do
        _G["LootButton"..i]:SetNormalTexture(nil)
        _G["LootButton"..i].IconBorder:SetTexture("Interface/AddOns/GW2_UI/textures/bag/bagitemborder")
    end
end

local function onMoverDragStart(self)
    self:StartMoving()
end
GW.AddForProfiling("lootframe", "onMoverDragStart", onMoverDragStart)

local function onMoverDragStop(self)
    if not self then
        return
    end

    self:StopMovingOrSizing()
    local x = self:GetLeft()
    local y = self:GetTop()

    -- re-anchor to LootFrameBg after the move
    self:ClearAllPoints()
    self:SetPoint("TOPLEFT", nil, "BOTTOMLEFT", x, y)

    -- store the updated position
    local pos = GW.GetSetting("LOOTFRAME_POSITION")
    if pos then
        wipe(pos)
    else
        pos = {}
    end
    pos.point = "TOPLEFT"
    pos.relativePoint = "BOTTOMLEFT"
    pos.xOfs = x
    pos.yOfs = y
    GW.SetSetting("LOOTFRAME_POSITION", pos)
end
GW.AddForProfiling("lootframe", "onMoverDragStop", onMoverDragStop)

local function SkinLooTFrame()
    LootFrameBg:Hide()
    LootFrameBg:SetPoint("TOPLEFT",0,-64)
    LootFrameBg:SetWidth(170)
    LootFrame.TitleBg:Hide()
    LootFrame.TopTileStreaks:Hide()
    LootFramePortrait:Hide()
    LootFramePortraitOverlay:Hide()
    LootFrameInset:Hide()
    LootFrame.NineSlice:Hide()

    local r = {LootFrame:GetRegions()}
    for _,c in pairs(r) do
        if c:GetObjectType()=="FontString" then
            c:Hide()
        end
    end

    CreateFrame("Frame","GwLootFrameTitle",LootFrame,"GwLootFrameTitle")
    GwLootFrameTitle:SetPoint("BOTTOMLEFT", LootFrameBg, "TOPLEFT")

    if GetCVar("lootUnderMouse") == "0" then
        local pos = GW.GetSetting("LOOTFRAME_POSITION")
        LootFrame:SetPoint(pos.point, nil, pos.relativePoint, pos.xOfs, pos.yOfs)
        LootFrame:SetScript("OnDragStart", onMoverDragStart)
        LootFrame:SetScript("OnDragStop", onMoverDragStop)
        LootFrame:EnableMouse(true)
        LootFrame:RegisterForDrag("LeftButton")
        LootFrame:SetMovable(true)
        hooksecurefunc("LootFrame_Show", function(self)
            local pos = GW.GetSetting("LOOTFRAME_POSITION")
            LootFrame:ClearAllPoints()
            LootFrame:SetPoint(pos.point, nil, pos.relativePoint, pos.xOfs, pos.yOfs)
        end)
    end

    LootFrameCloseButton:ClearAllPoints()
    LootFrameCloseButton:SetPoint("RIGHT",GwLootFrameTitle.BGRIGHT,"RIGHT",-5,-2)
    LootFrameCloseButton:SetSize(20,20)
    LootFrameCloseButton:SetNormalTexture("Interface\\AddOns\\GW2_UI\\textures\\window-close-button-normal")
    LootFrameCloseButton:SetPushedTexture("Interface\\AddOns\\GW2_UI\\textures\\window-close-button-hover")
    LootFrameCloseButton:SetHighlightTexture("Interface\\AddOns\\GW2_UI\\textures\\window-close-button-hover")

    LootFrameNext:SetFont(UNIT_NAME_FONT, 12)
    LootFramePrev:SetFont(UNIT_NAME_FONT, 12)
    LootFrameNext:SetTextColor(255 / 255, 241 / 255, 209 / 255)
    LootFramePrev:SetTextColor(255 / 255, 241 / 255, 209 / 255)

    LootFrameDownButton:SetNormalTexture("Interface\\AddOns\\GW2_UI\\textures\\arrowdown_up")
    LootFrameDownButton:SetPushedTexture("Interface\\AddOns\\GW2_UI\\textures\\arrowdown_up")
    LootFrameDownButton:SetHighlightTexture("Interface\\AddOns\\GW2_UI\\textures\\arrowdown_up")

    LootFrameUpButton:SetNormalTexture("Interface\\AddOns\\GW2_UI\\textures\\arrowup_down")
    LootFrameUpButton:SetPushedTexture("Interface\\AddOns\\GW2_UI\\textures\\arrowup_down")
    LootFrameUpButton:SetHighlightTexture("Interface\\AddOns\\GW2_UI\\textures\\arrowup_down")

    for i=1,4 do
        _G["LootButton"..i.."NameFrame"]:SetTexture("Interface\\AddOns\\GW2_UI\\textures\\character\\menu-hover")
        _G["LootButton"..i.."NameFrame"]:SetHeight(_G["LootButton"..i]:GetHeight())
        _G["LootButton"..i.."NameFrame"]:SetPoint("LEFT",_G["LootButton"..i],"RIGHT",0,0)

        _G["LootButton"..i.."IconTexture"]:SetTexCoord(0.1, 0.9, 0.1, 0.9)
        _G["LootButton"..i.."Text"]:SetFont(UNIT_NAME_FONT, 12)
    end

    hooksecurefunc("LootFrame_Update", updateLootFrameButtons)
end
GW.SkinLooTFrame = SkinLooTFrame
