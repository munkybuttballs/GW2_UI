local BAG_ITEM_SIZE = 45
local BAG_ITEM_PADDING = 5
local BAG_WINDOW_SIZE = 480
local BAG_WINDOW_CONTENT_HEIGHT = 0

local default_bag_frame ={
    'MainMenuBarBackpackButton',
    'CharacterBag0Slot',
    'CharacterBag1Slot',
    'CharacterBag2Slot',
    'CharacterBag3Slot',
}

local default_bag_frame_container ={
    'ContainerFrame1',
    'ContainerFrame2',
    'ContainerFrame3',
    'ContainerFrame4',
    'ContainerFrame5',
    'ContainerFrame6',
}



function gw_create_bgframe()
   local fm= CreateFrame('Frame','GwBagMoverFrame',UIParent,'GwBagMoverFrame') 
    GwBagMoverFrame:HookScript('OnDragStop',gw_onBankMove)
   local f= CreateFrame('Frame','GwBagFrame',UIParent,'GwBagFrame') 
    
    GwBagFrame:SetScript('OnHide',function() GwBagMoverFrame:Hide() GwBagFrameResize:Hide()  end)
    GwBagFrame:SetScript('OnShow',function() GwBagMoverFrame:Show() GwBagFrameResize:Show() end)
    
    GwBagFrame:Hide()
    

    ContainerFrame1:HookScript('OnShow',function() gw_bag_close() gw_relocate_searchbox() gw_update_bag_icons() GwBagContainer0:Show()  end)
    ContainerFrame2:HookScript('OnShow',function() gw_bag_close() gw_update_bag_icons() GwBagContainer1:Show() end)
    ContainerFrame3:HookScript('OnShow',function() gw_bag_close() gw_update_bag_icons() GwBagContainer2:Show() end)
    ContainerFrame4:HookScript('OnShow',function() gw_bag_close() gw_update_bag_icons() GwBagContainer3:Show() end)
    ContainerFrame5:HookScript('OnShow',function() gw_bag_close() gw_update_bag_icons() GwBagContainer4:Show() end)
    
    --BANK BAGS
    
 

    
    ContainerFrame1:HookScript('OnHide',function() gw_bag_close() gw_update_bag_icons() GwBagContainer0:Hide() end)
    ContainerFrame2:HookScript('OnHide',function() gw_bag_close() gw_update_bag_icons() GwBagContainer1:Hide() end)
    ContainerFrame3:HookScript('OnHide',function() gw_bag_close() gw_update_bag_icons() GwBagContainer2:Hide() end)
    ContainerFrame4:HookScript('OnHide',function() gw_bag_close() gw_update_bag_icons() GwBagContainer3:Hide() end)
    ContainerFrame5:HookScript('OnHide',function() gw_bag_close() gw_update_bag_icons() GwBagContainer4:Hide() end)

    
    gw_move_bagbar()
    
    gw_update_bag_icons()
    
    BagItemSearchBox:SetScript('OnEvent',function()
        gw_relocate_searchbox()
        gw_update_bag_icons()
        gw_update_free_slots()
  
    
    end)
    BagItemSearchBox:RegisterEvent('BAG_UPDATE_DELAYD')
    BagItemSearchBox:RegisterEvent('BAG_UPDATE')

    ContainerFrame1:SetFrameStrata('HIGH')
    ContainerFrame1:SetFrameLevel(5)
    ContainerFrame2:SetFrameStrata('HIGH')
    ContainerFrame2:SetFrameLevel(5)
    ContainerFrame3:SetFrameStrata('HIGH')
    ContainerFrame3:SetFrameLevel(5)
    ContainerFrame4:SetFrameStrata('HIGH')
    ContainerFrame4:SetFrameLevel(5)
    ContainerFrame5:SetFrameStrata('HIGH')
    ContainerFrame5:SetFrameLevel(5)
    ContainerFrame6:SetFrameStrata('HIGH')
    ContainerFrame6:SetFrameLevel(5)

end

function gw_move_bagbar()
    
    local y = 25
    
    for k,v in pairs(default_bag_frame) do
        
        _G[v]:ClearAllPoints()
        _G[v]:SetParent(GwBagFrame)
        _G[v]:SetPoint('TOPLEFT',GwBagFrame,'TOPLEFT',-35,-y)
        _G[v..'IconTexture']:SetTexCoord(0.1,0.9,0.1,0.9)
        _G[v]:SetNormalTexture(nil)
        _G[v]:SetHighlightTexture(nil)
        _G[v].IconBorder:SetTexture(nil)
        
        local s = _G[v]:GetScript('OnClick')
         _G[v]:SetScript('OnClick',function(self, b) 
                if b=='RightButton' then
                    
                    local parent = _G[default_bag_frame_container[k]];
                    PlaySound("igMainMenuOptionCheckBoxOn");
                    ToggleDropDownMenu(1, nil, parent.FilterDropDown, self, 0, 0);    
                    
                else
                    s(_G[v])
                end
            end)
     
        y=y+32
            
    end

end

function gw_bag_open() 
    gw_update_bag_icons()
end 
function gw_bag_close() 
    local o = false

   for i=1,12 do
        if i<6 then
            if _G['ContainerFrame'..i] and _G['ContainerFrame'..i]:IsShown() then

                _G['ContainerFrame'..i]:ClearAllPoints()
                _G['ContainerFrame'..i]:SetPoint('RIGHT',UIParent,'LEFT',0,0);
                o=true
            end
        else
            if _G['ContainerFrame'..i] and _G['ContainerFrame'..i]:IsShown() then
                _G['ContainerFrame'..i]:ClearAllPoints()
                _G['ContainerFrame'..i]:SetPoint('RIGHT',UIParent,'LEFT',0,9)
            end
        end
    end
    if o==false then
        GwBagFrame:Hide()
        return
    end
     GwBagFrame:Show()
end 

function gw_relocate_searchbox()

    BagItemSearchBox:ClearAllPoints()
    BagItemSearchBox:SetFont(UNIT_NAME_FONT,14)
    BagItemSearchBox.Instructions:SetFont(UNIT_NAME_FONT,14)
    BagItemSearchBox.Instructions:SetTextColor(178/255,178/255,178/255)
    BagItemSearchBox:SetPoint('TOPLEFT',GwBagFrame,'TOPLEFT',8,-40)
    BagItemSearchBox:SetPoint('TOPRIGHT',GwBagFrame,'TOPRIGHT',-8,-40)
    
    BagItemSearchBox.Left:SetTexture(nil)
    BagItemSearchBox.Right:SetTexture(nil)
    BagItemSearchBoxSearchIcon:Hide()
    BagItemSearchBox.Middle:SetTexture('Interface\\AddOns\\GW2_UI\\textures\\bag\\bagsearchbg')
  
    BagItemSearchBox:SetHeight(24)
    
    BagItemSearchBox.Middle:SetPoint('RIGHT',BagItemSearchBox,'RIGHT',0,0)
    
    BagItemSearchBox.Middle:SetHeight(24)
    BagItemSearchBox.Middle:SetTexCoord(0,1,0,1)
    BagItemSearchBox.SetPoint = function() end
    BagItemSearchBox.ClearAllPoints = function() end
    
    BagItemSearchBox:SetFrameLevel(5)
    
end


function gw_update_bag_icons(forceSize)
    gw_move_bagbar()
    local x = 8
    local y = 72
    for BAG_INDEX =1,5 do
        if _G['ContainerFrame'..BAG_INDEX] and _G['ContainerFrame'..BAG_INDEX]:IsShown()  then
            for i=1,40 do

                local slot = _G['ContainerFrame'..BAG_INDEX..'Item'..i]
                local slotIcon = _G['ContainerFrame'..BAG_INDEX..'Item'..i..'IconTexture']
                local slotIconBorder = _G['ContainerFrame'..BAG_INDEX..'Item'..i..'.IconBorder']
                local slotIconFlash = _G['ContainerFrame'..BAG_INDEX..'Item'..i..'.flash']
                local slotNormalTexture = _G['ContainerFrame'..BAG_INDEX..'Item'..i..'NormalTexture']

                if slot and slot:IsShown() then
                    
                    local backdrop =  _G['GwBagItemBackdrop'..'ContainerFrame'..BAG_INDEX..'Item'..i]
                    if backdrop==nil then
                      backdrop =  gw_create_bag_item_background('ContainerFrame'..BAG_INDEX..'Item'..i)
                    end
                    backdrop:SetParent(_G['ContainerFrame'..BAG_INDEX])
                        backdrop:SetFrameLevel(1)
                    
                    backdrop:SetPoint('TOPLEFT',GwBagFrame,'TOPLEFT',x,-y)
                    backdrop:SetPoint('TOPRIGHT',GwBagFrame,'TOPLEFT',x+BAG_ITEM_SIZE,-y)
                    backdrop:SetPoint('BOTTOMLEFT',GwBagFrame,'TOPLEFT',x,-y-BAG_ITEM_SIZE)
                    backdrop:SetPoint('BOTTOMRIGHT',GwBagFrame,'TOPLEFT',x+BAG_ITEM_SIZE,-y-BAG_ITEM_SIZE)
                        
                   _G['GwBagContainer'..(BAG_INDEX-1)]:SetSize(x,y)

                    slot:ClearAllPoints()

                    slot:SetPoint('TOPLEFT',GwBagFrame,'TOPLEFT',x,-y)
                    slot:SetPoint('TOPRIGHT',GwBagFrame,'TOPLEFT',x+BAG_ITEM_SIZE,-y)
                    slot:SetPoint('BOTTOMLEFT',GwBagFrame,'TOPLEFT',x,-y-BAG_ITEM_SIZE)
                    slot:SetPoint('BOTTOMRIGHT',GwBagFrame,'TOPLEFT',x+BAG_ITEM_SIZE,-y-BAG_ITEM_SIZE)
                    

                 

                    if slot.IconBorder then
                        slot.IconBorder:SetTexture('Interface\\AddOns\\GW2_UI\\textures\\bag\\bagitemborder')
                        slot.IconBorder:SetSize(BAG_ITEM_SIZE,BAG_ITEM_SIZE)
                        if slot.IconBorder.GwhasBeenHooked==nil then
                            hooksecurefunc(slot.IconBorder,'SetVertexColor',function()
                                 slot.IconBorder:SetTexture('Interface\\AddOns\\GW2_UI\\textures\\bag\\bagitemborder')
                            end)
                            slot.IconBorder.GwhasBeenHooked =true
                        end 
                        
                    end
                    if slotNormalTexture then
                        slotNormalTexture:SetSize(BAG_ITEM_SIZE,BAG_ITEM_SIZE)
                        slot:SetNormalTexture(nil)
                    end 
                    if slot.flash then
                        slot.flash:SetSize(BAG_ITEM_SIZE,BAG_ITEM_SIZE)
                    end

                    slotIcon:SetTexCoord(0.1,0.9,0.1,0.9)

                    x=x+BAG_ITEM_SIZE + BAG_ITEM_PADDING

                    if x>BAG_WINDOW_SIZE then
                        x =8
                        y = y + BAG_ITEM_SIZE + BAG_ITEM_PADDING
                    end
                    
                
                             
           
                end

            end
            
        end
    end
    
    GwBagFrame:SetHeight(y+BAG_ITEM_SIZE+BAG_ITEM_PADDING)
    BAG_WINDOW_CONTENT_HEIGHT= y+BAG_ITEM_SIZE+BAG_ITEM_PADDING
    gw_bagFrameOnResize(GwBagFrame,forceSize)
    
    if (BAG_WINDOW_SIZE/45)<11 and BAG_ITEM_SIZE>32 then
        BAG_ITEM_SIZE = 32       
        gw_update_bag_icons(false)
    else
        if BAG_WINDOW_CONTENT_HEIGHT>512 and BAG_ITEM_SIZE>32 then
            BAG_ITEM_SIZE = 32       
            gw_update_bag_icons(false)
        else
            BAG_ITEM_SIZE = 45
        end
    end

    
    
end


function gw_create_bag_item_background(name)
    local bg = CreateFrame('Frame','GwBagItemBackdrop'..name,GwBagFrame,'GwBagItemBackdrop')

    return bg
end


function gw_update_player_money()
   money = GetMoney(); 
    
    local gold = math.floor(money / (COPPER_PER_SILVER * SILVER_PER_GOLD));
    local silver = math.floor((money - (gold * COPPER_PER_SILVER * SILVER_PER_GOLD)) / COPPER_PER_SILVER);
    local copper = mod(money, COPPER_PER_SILVER);

                
                

    GwBagFrameBronze:SetText(copper)

    GwBagFrameSilver:SetText(silver)
                 
    GwBagFrameGold:SetText(gold)
    
end

function gw_update_free_slots()
          local free = 0
        local full = 0
            
        for i=0,4 do 
            free =  free + GetContainerNumFreeSlots(i)
            full =  full + GetContainerNumSlots(i)
        end
            
        free =  full - free
        local bag_space_string =free..' / '..full
        GwBagFrameBagSpaceString:SetText(bag_space_string); 
end

function gw_onBagMove()
     GwBagFrameResize:SetPoint('BOTTOMRIGHT',GwBagFrame,'BOTTOMRIGHT',0,0)
end
function gw_bagFrameOnResize(self,forceSize)
    if forceSize==nil then
        forceSize = true
    end
    
    local w = self:GetWidth()
    local h = self:GetHeight()
    
    
    w = math.max(512,w)
    h = math.max(350,math.max(BAG_WINDOW_CONTENT_HEIGHT,h))
    
    BAG_WINDOW_SIZE = w - (BAG_ITEM_PADDING * 3) -32
    
    self:SetSize(w,h)
    
    if  forceSize==false then
        return
    end
   
    gw_update_bag_icons(false)
    

end 
